### VAD

静音检测，归属于音频编码，处于音频编码前一步。

方法就是对每帧的采样点进行累加求平均，得到的结果和门限进行比较。

语音检测分为固定模式和动态模式。固定模式就是累加值和给定的门限比较，动态模式的具体方法还不确定。

#### 语音检测的调用关系

​	g711_encode()->pjmedia_silence_det_detect（）

#### 函数分析

##### pjmedia_silence_det_detect（）

		1. 计算音频帧的平均值 level
  		2. 根据不同的模式比较 level

##### pjmedia_silence_det_apply(sd, level)

	1. 无模式，返回 false
 	2. 固定模式，比较固定阈值
 	3. 动态模式：
      	1. 大于阈值，切换状态，更新 recent_level
      	2. 小于阈值，更新状态，更新计算 recent_level

```c
PJ_DEF(pj_bool_t) pjmedia_silence_det_apply(pjmedia_silence_det *sd,
                                            pj_uint32_t level) {
    int avg_recent_level;

    if (sd->mode == VAD_MODE_NONE)
        return PJ_FALSE;

    if (sd->mode == VAD_MODE_FIXED)
        return (level < sd->threshold);

    /* Calculating recent level */
    sd->sum_level += level;
    ++sd->sum_cnt;
    avg_recent_level = (sd->sum_level / sd->sum_cnt);

    if (level > sd->threshold ||
        level >= PJMEDIA_SILENCE_DET_MAX_THRESHOLD) {
        sd->silence_timer = 0;
        sd->voiced_timer += sd->ptime;

        switch (sd->state) {
            case STATE_VOICED:
                if (sd->voiced_timer > sd->recalc_on_voiced) {
                    /* Voiced for long time (>recalc_on_voiced), current
                     * threshold seems to be too low.
                     */
                    sd->threshold = (avg_recent_level + sd->threshold) >> 1;
                    TRACE_((THIS_FILE, "Re-adjust threshold (in talk burst)"
                                       "to %d", sd->threshold));

                    sd->voiced_timer = 0;

                    /* Reset sig_level */
                    sd->sum_level = avg_recent_level;
                    sd->sum_cnt = 1;
                }
                break;

            case STATE_SILENCE:
                TRACE_((THIS_FILE, "Starting talk burst (level=%d threshold=%d)",
                        level, sd->threshold));

            case STATE_START_SILENCE:
                sd->state = STATE_VOICED;

                /* Reset sig_level */
                sd->sum_level = level;
                sd->sum_cnt = 1;

                break;

            default:
                pj_assert(0);
                break;
        }
    } else {
        sd->voiced_timer = 0;
        sd->silence_timer += sd->ptime;

        switch (sd->state) {
            case STATE_SILENCE:
                if (sd->silence_timer >= sd->recalc_on_silence) {
                    sd->threshold = avg_recent_level << 1;
                    TRACE_((THIS_FILE, "Re-adjust threshold (in silence)"
                                       "to %d", sd->threshold));

                    sd->silence_timer = 0;

                    /* Reset sig_level */
                    sd->sum_level = avg_recent_level;
                    sd->sum_cnt = 1;
                }
                break;

            case STATE_VOICED:
                sd->state = STATE_START_SILENCE;

                /* Reset sig_level */
                sd->sum_level = level;
                sd->sum_cnt = 1;

            case STATE_START_SILENCE:
                if (sd->silence_timer >= sd->before_silence) {
                    sd->state = STATE_SILENCE;
                    sd->threshold = avg_recent_level << 1;
                    TRACE_((THIS_FILE, "Starting silence (level=%d "
                                       "threshold=%d)", level, sd->threshold));

                    /* Reset sig_level */
                    sd->sum_level = avg_recent_level;
                    sd->sum_cnt = 1;
                }
                break;

            default:
                pj_assert(0);
                break;
        }
    }

    return (sd->state == STATE_SILENCE);
}
```

