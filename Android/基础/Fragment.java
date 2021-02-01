/**
     * 懒加载：
     *      当对象需要用到（对视图可见）的时候才会加载
     *      setUserVisibleHint(),这个方法的回调在onAttach之前，用来判断当前Fragment是否对用户可见，并且每次切换都会回调。
     * 生命周期：
     *      onAttach():当Fragment首次附加到其活动时调用
     *      onCreate():创建Fragment的时候回调,当你回调onPause、onStop的时候（即暂停，停止），你想保存的数据如果我们要为fragment启动一个后台线程，可以考虑将代码放于这里。
     *      onCreateView()；给当前的Fragment绘制ui布局
     *      onActivityCreate()：当Fragment被所在的Activity启动完成后回调该方法。在onActivityCreated调用之前activity的onCreate可能还没有完成
     *      onStart()：启动Fragment 启动时回调，此时Fragment可见
     *      onResume()：Fragment 进入前台，可获取焦点
     *      onPause()
     *      onStop()
     *      onDestroyView()
     *      onDestroy()
     *      onDetach()
     *      onSaveInstanceState():保存状态（注意在Fragment是在onCreate()，onCreateView()，或onActvityCreate()中进行恢复而不是像Activity在onRestoreInstanceState中恢复）
     *
     * 事务操作：
     *      对Fragment的事务操作都是通过FragmentTransaction来执行。操作大致可以分为两类：
     *          显示：add() replace() show() attach()
     *          隐藏：remove() hide() detach()　
     *      调用show() & hide()方法时，Fragment的生命周期方法并不会被执行，仅仅是Fragment的View被显示或者​隐藏。
     *      执行replace()时（至少两个Fragment），会执行第二个Fragment的onAttach()方法、执行第一个Fragment的onPause()-onDetach()方法，同时containerView会detach第一个Fragment的View。
     *      add()方法执行onAttach()-onResume()的生命周期，相对的remove()就是执行完成剩下的onPause()-onDetach()周期。
     *
     *      onHiddenChanged()
     *          当使用add()+show()，hide()跳转新的Fragment时，旧的Fragment回调onHiddenChanged()，不会回调onStop()等生命周期方法，而新的Fragment在创建时是不会回调onHiddenChanged()。
     *
     * addToBackStack()
     *      在调用commit()之前的所有应用的变更被作为一个单独的事务添加到后台栈中，并且BACK键可以将它们一起回退。
     * popBackStack()
     *   popBackStack和popBackStackImmediate的区别在于前者是加入到主线队列的末尾，等其它任务完成后才开始出栈，后者是队列内的任务立即执行，再将出栈任务放到队列尾（可以理解为立即出栈）。
     *  如果你popBackStack多个Fragment后，紧接着beginTransaction() add新的一个Fragment，接着发生了“内存重启”后，你再执行popBackStack()，app就会Crash，解决方案是postDelay出栈动画时间再执行其它事务，但是根据我的观察不是很稳定。
     *  我的建议是：如果你想出栈多个Fragment，你应尽量使用popBackStackImmediate(tag/id)，而不是popBackStack(tag/id)，如果你想在出栈后，立刻beginTransaction()开始一项事务，你应该把事务的代码post/postDelay到主线程的消息队列里
     *
     *  对于Fragment，getFragmentManager()是获取的是父Fragment(如果没有，则是FragmentActivity)的FragmentManager对象，而getChildFragmentManager()是获取自己的FragmentManager对象。
     *
     *
     * commit()
     *  调用commit()并不立刻执行事务，相反，而是采取预约方式，一旦Activity的界面线程（主线程）准备好便可运行起来。然而，如果有必要的话，你可以从界面线程调用executePendingTransations()立即执行由commit()提交的事务。
     *  只能在Activity保存状态（当用户离开Activity时）之前用commit()提交事务。如果你尝试在那时之后提交，会抛出一个异常。这是因为如果Activity需要被恢复，提交后的状态会被丢失。对于这类丢失提交的情况，可使用commitAllowingStateLoss()
     *
     * Activity向Fragment传参:
     *  初始化Fragment实例并setArguments()
     *
     * Fragment && Fragment 数据交互
     *  原理其实也是通过使用onActivityResult回调，完成Fragment && Fragment 的数据交互，这其中有两个比较重要的方法：Fragment.setTargetFragment、getTargetFragment()
     *
     *  1. 在 FirstFragment 中，通过setTargetFragment来连接需要交互的Fragment：
     *      secondFragment.setTargetFragment(FirstFragment.this, REQUEST_CODE);
     *  接着实现onActivityResult,处理传递过来的数据：
     *      @Override
     *      public void onActivityResult(int requestCode, int resultCode, Intent data) {
     *        super.onActivityResult(requestCode, resultCode, data);
     *        if(resultCode != Activity.RESULT_OK){
     *            return;
     *        }else{
     *            Integer str = data.getIntExtra("key",-1);
     *            //处理数据...
     *        }
     *      }
     *  在 SecondFragment 中调用sendResult（）方法，回传数据给 FirstFragment:
     *
     *      private void sendResult(int resultOk) {
     *         if(getTargetFragment() == null){
     *             return;
     *         }else{
     *             Intent intent = new Intent();
     *             intent.putExtra("key", 520);
     *             getTargetFragment().onActivityResult(FirstFragment.REQUEST_CODE,resultOk,intent);
     *         }
     *      }
     *
     */