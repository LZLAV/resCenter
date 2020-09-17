cmake_minimum_required(VERSION 3.4.1)

project(opus)

#pull submodule if not already here
execute_process(COMMAND git submodule update --init -- .
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

option(OPUS_USE_ALLOCA "USE_ALLOCA" ON)
option(OPUS_FIXED_POINT "FIXED_POINT" OFF)
option(OPUS_DISABLE_FLOAT_API "DISABLE_FLOAT_API" OFF)

set(OPUS_INCLUDE_DIR
        ${CMAKE_CURRENT_SOURCE_DIR}/../../opus1_3_1/opus
        )

set(SILK_SOURCES
        ../../opus1_3_1/silk/CNG.c
        ../../opus1_3_1/silk/code_signs.c
        ../../opus1_3_1/silk/init_decoder.c
        ../../opus1_3_1/silk/decode_core.c
        ../../opus1_3_1/silk/decode_frame.c
        ../../opus1_3_1/silk/decode_parameters.c
        ../../opus1_3_1/silk/decode_indices.c
        ../../opus1_3_1/silk/decode_pulses.c
        ../../opus1_3_1/silk/decoder_set_fs.c
        ../../opus1_3_1/silk/dec_API.c
        ../../opus1_3_1/silk/enc_API.c
        ../../opus1_3_1/silk/encode_indices.c
        ../../opus1_3_1/silk/encode_pulses.c
        ../../opus1_3_1/silk/gain_quant.c
        ../../opus1_3_1/silk/interpolate.c
        ../../opus1_3_1/silk/LP_variable_cutoff.c
        ../../opus1_3_1/silk/NLSF_decode.c
        ../../opus1_3_1/silk/NSQ.c
        ../../opus1_3_1/silk/NSQ_del_dec.c
        ../../opus1_3_1/silk/PLC.c
        ../../opus1_3_1/silk/shell_coder.c
        ../../opus1_3_1/silk/tables_gain.c
        ../../opus1_3_1/silk/tables_LTP.c
        ../../opus1_3_1/silk/tables_NLSF_CB_NB_MB.c
        ../../opus1_3_1/silk/tables_NLSF_CB_WB.c
        ../../opus1_3_1/silk/tables_other.c
        ../../opus1_3_1/silk/tables_pitch_lag.c
        ../../opus1_3_1/silk/tables_pulses_per_block.c
        ../../opus1_3_1/silk/VAD.c
        ../../opus1_3_1/silk/control_audio_bandwidth.c
        ../../opus1_3_1/silk/quant_LTP_gains.c
        ../../opus1_3_1/silk/VQ_WMat_EC.c
        ../../opus1_3_1/silk/HP_variable_cutoff.c
        ../../opus1_3_1/silk/NLSF_encode.c
        ../../opus1_3_1/silk/NLSF_VQ.c
        ../../opus1_3_1/silk/NLSF_unpack.c
        ../../opus1_3_1/silk/NLSF_del_dec_quant.c
        ../../opus1_3_1/silk/process_NLSFs.c
        ../../opus1_3_1/silk/stereo_LR_to_MS.c
        ../../opus1_3_1/silk/stereo_MS_to_LR.c
        ../../opus1_3_1/silk/check_control_input.c
        ../../opus1_3_1/silk/control_SNR.c
        ../../opus1_3_1/silk/init_encoder.c
        ../../opus1_3_1/silk/control_codec.c
        ../../opus1_3_1/silk/A2NLSF.c
        ../../opus1_3_1/silk/ana_filt_bank_1.c
        ../../opus1_3_1/silk/biquad_alt.c
        ../../opus1_3_1/silk/bwexpander_32.c
        ../../opus1_3_1/silk/bwexpander.c
        ../../opus1_3_1/silk/debug.c
        ../../opus1_3_1/silk/decode_pitch.c
        ../../opus1_3_1/silk/inner_prod_aligned.c
        ../../opus1_3_1/silk/lin2log.c
        ../../opus1_3_1/silk/log2lin.c
        ../../opus1_3_1/silk/LPC_analysis_filter.c
        ../../opus1_3_1/silk/LPC_inv_pred_gain.c
        ../../opus1_3_1/silk/table_LSF_cos.c
        ../../opus1_3_1/silk/NLSF2A.c
        ../../opus1_3_1/silk/NLSF_stabilize.c
        ../../opus1_3_1/silk/NLSF_VQ_weights_laroia.c
        ../../opus1_3_1/silk/pitch_est_tables.c
        ../../opus1_3_1/silk/resampler.c
        ../../opus1_3_1/silk/resampler_down2_3.c
        ../../opus1_3_1/silk/resampler_down2.c
        ../../opus1_3_1/silk/resampler_private_AR2.c
        ../../opus1_3_1/silk/resampler_private_down_FIR.c
        ../../opus1_3_1/silk/resampler_private_IIR_FIR.c
        ../../opus1_3_1/silk/resampler_private_up2_HQ.c
        ../../opus1_3_1/silk/resampler_rom.c
        ../../opus1_3_1/silk/sigm_Q15.c
        ../../opus1_3_1/silk/sort.c
        ../../opus1_3_1/silk/sum_sqr_shift.c
        ../../opus1_3_1/silk/stereo_decode_pred.c
        ../../opus1_3_1/silk/stereo_encode_pred.c
        ../../opus1_3_1/silk/stereo_find_predictor.c
        ../../opus1_3_1/silk/stereo_quant_pred.c
        ../../opus1_3_1/silk/LPC_fit.c
        )

set(SILK_SOURCES_SSE4_1
        ../../opus1_3_1/silk/x86/NSQ_sse.c
        ../../opus1_3_1/silk/x86/NSQ_del_dec_sse.c
        ../../opus1_3_1/silk/x86/x86_silk_map.c
        ../../opus1_3_1/silk/x86/VAD_sse.c
        ../../opus1_3_1/silk/x86/VQ_WMat_EC_sse.c
        )

set(SILK_SOURCES_ARM_NEON_INTR
        ../../opus1_3_1/silk/arm/arm_silk_map.c
        ../../opus1_3_1/silk/arm/NSQ_del_dec_neon_intr.c
        ../../opus1_3_1/silk/arm/NSQ_neon.c
        )

set(SILK_SOURCES_FIXED
        ../../opus1_3_1/silk/fixed/LTP_analysis_filter_FIX.c
        ../../opus1_3_1/silk/fixed/LTP_scale_ctrl_FIX.c
        ../../opus1_3_1/silk/fixed/corrMatrix_FIX.c
        ../../opus1_3_1/silk/fixed/encode_frame_FIX.c
        ../../opus1_3_1/silk/fixed/find_LPC_FIX.c
        ../../opus1_3_1/silk/fixed/find_LTP_FIX.c
        ../../opus1_3_1/silk/fixed/find_pitch_lags_FIX.c
        ../../opus1_3_1/silk/fixed/find_pred_coefs_FIX.c
        ../../opus1_3_1/silk/fixed/noise_shape_analysis_FIX.c
        ../../opus1_3_1/silk/fixed/process_gains_FIX.c
        ../../opus1_3_1/silk/fixed/regularize_correlations_FIX.c
        ../../opus1_3_1/silk/fixed/residual_energy16_FIX.c
        ../../opus1_3_1/silk/fixed/residual_energy_FIX.c
        ../../opus1_3_1/silk/fixed/warped_autocorrelation_FIX.c
        ../../opus1_3_1/silk/fixed/apply_sine_window_FIX.c
        ../../opus1_3_1/silk/fixed/autocorr_FIX.c
        ../../opus1_3_1/silk/fixed/burg_modified_FIX.c
        ../../opus1_3_1/silk/fixed/k2a_FIX.c
        ../../opus1_3_1/silk/fixed/k2a_Q16_FIX.c
        ../../opus1_3_1/silk/fixed/pitch_analysis_core_FIX.c
        ../../opus1_3_1/silk/fixed/vector_ops_FIX.c
        ../../opus1_3_1/silk/fixed/schur64_FIX.c
        ../../opus1_3_1/silk/fixed/schur_FIX.c
        )

set(SILK_SOURCES_FIXED_SSE4_1
        ../../opus1_3_1/silk/fixed/x86/vector_ops_FIX_sse.c
        ../../opus1_3_1/silk/fixed/x86/burg_modified_FIX_sse.c
        )

set(SILK_SOURCES_FLOAT
        ../../opus1_3_1/silk/float/apply_sine_window_FLP.c
        ../../opus1_3_1/silk/float/corrMatrix_FLP.c
        ../../opus1_3_1/silk/float/encode_frame_FLP.c
        ../../opus1_3_1/silk/float/find_LPC_FLP.c
        ../../opus1_3_1/silk/float/find_LTP_FLP.c
        ../../opus1_3_1/silk/float/find_pitch_lags_FLP.c
        ../../opus1_3_1/silk/float/find_pred_coefs_FLP.c
        ../../opus1_3_1/silk/float/LPC_analysis_filter_FLP.c
        ../../opus1_3_1/silk/float/LTP_analysis_filter_FLP.c
        ../../opus1_3_1/silk/float/LTP_scale_ctrl_FLP.c
        ../../opus1_3_1/silk/float/noise_shape_analysis_FLP.c
        ../../opus1_3_1/silk/float/process_gains_FLP.c
        ../../opus1_3_1/silk/float/regularize_correlations_FLP.c
        ../../opus1_3_1/silk/float/residual_energy_FLP.c
        ../../opus1_3_1/silk/float/warped_autocorrelation_FLP.c
        ../../opus1_3_1/silk/float/wrappers_FLP.c
        ../../opus1_3_1/silk/float/autocorrelation_FLP.c
        ../../opus1_3_1/silk/float/burg_modified_FLP.c
        ../../opus1_3_1/silk/float/bwexpander_FLP.c
        ../../opus1_3_1/silk/float/energy_FLP.c
        ../../opus1_3_1/silk/float/inner_product_FLP.c
        ../../opus1_3_1/silk/float/k2a_FLP.c
        ../../opus1_3_1/silk/float/LPC_inv_pred_gain_FLP.c
        ../../opus1_3_1/silk/float/pitch_analysis_core_FLP.c
        ../../opus1_3_1/silk/float/scale_copy_vector_FLP.c
        ../../opus1_3_1/silk/float/scale_vector_FLP.c
        ../../opus1_3_1/silk/float/schur_FLP.c
        ../../opus1_3_1/silk/float/sort_FLP.c
        )

set(CELT_SOURCES
        ../../opus1_3_1/celt/bands.c
        ../../opus1_3_1/celt/celt.c
        ../../opus1_3_1/celt/celt_encoder.c
        ../../opus1_3_1/celt/celt_decoder.c
        ../../opus1_3_1/celt/cwrs.c
        ../../opus1_3_1/celt/entcode.c
        ../../opus1_3_1/celt/entdec.c
        ../../opus1_3_1/celt/entenc.c
        ../../opus1_3_1/celt/kiss_fft.c
        ../../opus1_3_1/celt/laplace.c
        ../../opus1_3_1/celt/mathops.c
        ../../opus1_3_1/celt/mdct.c
        ../../opus1_3_1/celt/modes.c
        ../../opus1_3_1/celt/pitch.c
        ../../opus1_3_1/celt/celt_lpc.c
        ../../opus1_3_1/celt/quant_bands.c
        ../../opus1_3_1/celt/rate.c
        ../../opus1_3_1/celt/vq.c
        )

set(CELT_SOURCES_SSE
        ../../opus1_3_1/celt/x86/x86cpu.c
        ../../opus1_3_1/celt/x86/x86_celt_map.c
        ../../opus1_3_1/celt/x86/pitch_sse.c
        )

set(CELT_SOURCES_SSE2
        ../../opus1_3_1/celt/x86/pitch_sse2.c
        ../../opus1_3_1/celt/x86/vq_sse2.c
        )

set(CELT_SOURCES_SSE4_1
        ../../opus1_3_1/celt/x86/celt_lpc_sse.c
        ../../opus1_3_1/celt/x86/pitch_sse4_1.c
        )

set(CELT_SOURCES_ARM
        ../../opus1_3_1/celt/arm/armcpu.c
        ../../opus1_3_1/celt/arm/arm_celt_map.c
        )

set(CELT_SOURCES_ARM_ASM
        ../../opus1_3_1/celt/arm/celt_pitch_xcorr_arm.s
        )

set(CELT_AM_SOURCES_ARM_ASM
        ../../opus1_3_1/celt/arm/armopts.s.in
        )

set(CELT_SOURCES_ARM_NEON_INTR
        ../../opus1_3_1/celt/arm/celt_neon_intr.c
        )

set(CELT_SOURCES_ARM_NE10
        ../../opus1_3_1/celt/arm/celt_ne10_fft.c
        ../../opus1_3_1/celt/arm/celt_ne10_mdct.c
        )

set(OPUS_HEADER
        ../../opus1_3_1/opus/opus.h
        ../../opus1_3_1/opus/opus_custom.h
        ../../opus1_3_1/opus/opus_defines.h
        ../../opus1_3_1/opus/opus_multistream.h
        ../../opus1_3_1/opus/opus_types.h
        )

set(OPUS_SOURCES
        ../../opus1_3_1/opus.c
        ../../opus1_3_1/opus_decoder.c
        ../../opus1_3_1/opus_encoder.c
        ../../opus1_3_1/opus_multistream.c
        ../../opus1_3_1/opus_multistream_encoder.c
        ../../opus1_3_1/opus_multistream_decoder.c
        ../../opus1_3_1/repacketizer.c
        )

set(OPUS_SOURCES_FLOAT
        ../../opus1_3_1/analysis.c
        ../../opus1_3_1/mlp.c
        ../../opus1_3_1/mlp_data.c
        )

if(OPUS_FIXED_POINT)
    list(APPEND SILK_SOURCES ${SILK_SOURCES_FIXED})
    if(HAVE_SSE4_1)
        list(APPEND SILK_SOURCES ${SILK_SOURCES_SSE4_1} ${SILK_SOURCES_FIXED_SSE4_1})
    endif(HAVE_SSE4_1)
else(OPUS_FIXED_POINT)
    list(APPEND SILK_SOURCES ${SILK_SOURCES_FLOAT})
    if (HAVE_SSE4_1)
        list(APPEND SILK_SOURCES ${SILK_SOURCES_SSE4_1})
    endif(HAVE_SSE4_1)
endif(OPUS_FIXED_POINT)

if (NOT OPUS_DISABLE_FLOAT_API)
    list(APPEND OPUS_SOURCES ${OPUS_SOURCES_FLOAT})
endif(NOT OPUS_DISABLE_FLOAT_API)

if(HAVE_SSE)
    list(APPEND CELT_SOURCES ${CELT_SOURCES_SSE})
endif(HAVE_SSE)

if(HAVE_SSE2)
    list(APPEND CELT_SOURCES ${CELT_SOURCES_SSE2})
endif(HAVE_SSE2)

if(HAVE_SSE4_1)
    list(APPEND CELT_SOURCES ${CELT_SOURCES_SSE4_1})
endif(HAVE_SSE4_1)

if(CPU_ARM)
    list(APPEND CELT_SOURCES ${CELT_SOURCES_ARM})
    list(APPEND SILK_SOURCES ${SILK_SOURCES_ARM})

    if(HAVE_ARM_NEON_INTR)
        list(APPEND CELT_SOURCES ${CELT_SOURCES_ARM_NEON_INTR})
        list(APPEND SILK_SOURCES ${SILK_SOURCES_ARM_NEON_INTR})
    endif(HAVE_ARM_NEON_INTR)

    if(HAVE_ARM_NE10)
        list(APPEND CELT_SOURCES ${CELT_SOURCES_ARM_NE10})
    endif(HAVE_ARM_NE10)

    #if(OPUS_ARM_EXTERNAL_ASM)
    #	noinst_LTLIBRARIES = libarmasm.la
    #	libarmasm_la_SOURCES = $(CELT_SOURCES_ARM_ASM:.s=-gnu.S)
    #	BUILT_SOURCES = $(CELT_SOURCES_ARM_ASM:.s=-gnu.S) \
    #	$(CELT_AM_SOURCES_ARM_ASM:.s.in=.s) \
    #	$(CELT_AM_SOURCES_ARM_ASM:.s.in=-gnu.S)
    #endif(OPUS_ARM_EXTERNAL_ASM)
endif(CPU_ARM)

# It is strongly recommended to uncomment one of these
# VAR_ARRAYS: Use C99 variable-length arrays for stack allocation
# USE_ALLOCA: Use alloca() for stack allocation
# If none is defined, then the fallback is a non-threadsafe global array
if (OPUS_USE_ALLOCA)
    add_definitions(-DUSE_ALLOCA)
else (OPUS_USE_ALLOCA)
    add_definitions(-DVAR_ARRAYS)
endif (OPUS_USE_ALLOCA)

# These options affect performance
# HAVE_LRINTF: Use C99 intrinsics to speed up float-to-int conversion
add_definitions(-DHAVE_LRINTF)

add_definitions(-DOPUS_BUILD)

if (OPUS_FIXED_POINT)
    add_definitions(-DFIXED_POINT=1 -DDISABLE_FLOAT_API)
endif (OPUS_FIXED_POINT)


add_library(opus STATIC ${CELT_SOURCES} ${SILK_SOURCES} ${OPUS_SOURCES})
target_compile_options(opus PRIVATE $<$<OR:$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:GNU>>:
        -Wall
        -Wextra
        -Wcast-align
        -Wnested-externs
        -Wshadow
        -Wstrict-prototypes
        >)
target_include_directories(opus PUBLIC ${OPUS_INCLUDE_DIR})
target_include_directories(opus PRIVATE
        ../../opus1_3_1/silk
        ../../opus1_3_1/silk/float
        ../../opus1_3_1/silk/fixed
        ../../opus1_3_1/celt
        ../../opus1_3_1/
        )