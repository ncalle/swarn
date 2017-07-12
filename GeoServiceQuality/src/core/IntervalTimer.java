package core;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.ejb.Singleton;
import javax.ejb.AccessTimeout;
import javax.ejb.EJB;
import javax.ejb.Schedule;
import javax.ejb.Startup;
import javax.ejb.Timeout;
import javax.ejb.Timer;
import javax.ejb.TimerConfig;

import dao.EvaluationBean;
import dao.EvaluationBeanRemote;
import dao.EvaluationPeriodicBean;
import dao.EvaluationPeriodicBeanRemote;

import entity.EvaluationPeriodic;


@Singleton
@Startup
public class IntervalTimer {
	
	static int TIMEOUT_SERVICE = 18000;
	
	 @EJB
	 private EvaluationBeanRemote evaluationDao = new EvaluationBean();
	 private EvaluationPeriodicBeanRemote evaluationPeriodicDao = new EvaluationPeriodicBean();

	 private List<EvaluationPeriodic> listPeriodicObjects;

	 
    @PostConstruct
    public void applicationStartup() {
    	
    	//Timer automatico programado
    	scheduleTimer();
    	
    }
    
    //@Schedule(minute="*/15", hour="*", persistent = true) cada 15 min
    @Schedule(hour="*/24", persistent = true) // cada 24 hrs
    public void scheduleTimer() {
    	TimerConfig timerConfig = new TimerConfig();
        timerConfig.setInfo("Timer");
        
        listPeriodicObjects = evaluationPeriodicDao.list();
        for(EvaluationPeriodic e:listPeriodicObjects){
        	
        	//Se evaluan los servicios de hasta 3 meses antes
        	Date d = e.getPeriodic();
        	Calendar calendar = Calendar.getInstance();
        	calendar.add( Calendar.MONTH ,  -3 );
        	boolean olderDate = d.compareTo( calendar.getTime() ) < 0;
        	///System.out.println("getPeriodic().. " + e.getPeriodic() + " olderDate:: " + olderDate);
        	
        	if(!olderDate){
        		boolean success = metricServiceAvailable(e.getMeasurableObjectUrl(), TIMEOUT_SERVICE);
            	System.out.println("checkService.. " + success);
            	
            	int count = e.getEvaluatedCount();
            	int countSuccess= e.getSuccessCount();
            	
            	count++;
            	if(success){
            		countSuccess = countSuccess + 1;
            	}
            	
            	e.setEvaluatedCount(count);
            	e.setSuccessCount(countSuccess);
            	float f = ((float) countSuccess/count) * 100;
            	e.setSuccessPercentage((int)f);
            	
            	System.out.println(e.toString());
            	
            	evaluationPeriodicDao.update(e);
            	
        	} else {
        		evaluationPeriodicDao.delete(e);
        	}
        	
        }
        
    }
    
    
    @Timeout
    @AccessTimeout(value = 20, unit = TimeUnit.MINUTES)
    public void process(Timer timer) {
    	System.out.println("process timer..");
    }
    
    
    public boolean metricServiceAvailable(String url, int timeout) {
        url = url.replaceFirst("^https", "http"); 

        try {
        	URL u = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) u.openConnection();
            connection.setConnectTimeout(timeout);
            connection.setReadTimeout(timeout);
            connection.setRequestMethod("GET"); //HEAD no soportado en algun caso
            connection.setRequestProperty("Accept", "application/xml");
            connection.setRequestProperty("Content-Type", "application/xml; charset=\"utf-8\"");
            int responseCode = connection.getResponseCode();
            //System.out.println("responseCode " +responseCode);
            return (200 <= responseCode && responseCode <= 399);
        } catch (IOException exception) {
            return false;
        }
    }
    
}
