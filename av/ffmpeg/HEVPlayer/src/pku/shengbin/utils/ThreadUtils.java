package pku.shengbin.utils;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadUtils {
	//»º´æÏß³Ì³Ø
	private static ExecutorService pool=Executors.newCachedThreadPool();
	private static ThreadUtils threadUtils;
	
	public static ThreadUtils getInstance(){
		if(threadUtils==null){
			threadUtils = new ThreadUtils();
		}
		if(pool==null){
			pool=Executors.newCachedThreadPool();
		}
		return threadUtils;
	}
	
	public void execu(Thread thread){
		pool.execute(thread);
	}
}
