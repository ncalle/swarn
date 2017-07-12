package service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;

import org.primefaces.model.DualListModel;

import entity.Metric;
import entity.Profile;
import dao.DAOException;
import dao.MetricBean;
import dao.MetricBeanRemote;
import dao.ProfileBean;
import dao.ProfileBeanRemote;


@ManagedBean(name="profileBeanAdd")
@RequestScoped
public class ProfileBeanAdd {
	
    private String name;
    private String granularity;
	private List<Metric> listMetrics;
    private DualListModel<Metric> dualListMetrics;
    private Boolean weight;
    
	@EJB
    private ProfileBeanRemote pDao = new ProfileBean();
    private MetricBeanRemote mDao = new MetricBean();
	
    
	@PostConstruct
	private void init()
	{
		listMetrics = mDao.list();
		//Se inicializa con el primer elemento a mostrar
		filter("Ide");
	}
	

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
	public String getGranularity() {
		return granularity;
	}
	
	public void setGranularity(String granularity) {
		this.granularity = granularity;
	}
				
	public DualListModel<Metric> getDualListMetrics() {
		return dualListMetrics;
	}

	public void setDualListMetrics(DualListModel<Metric> dualListMetrics) {
		this.dualListMetrics = dualListMetrics;
	}
	    
    public List<Metric> getListMetrics() {
		return listMetrics;
	}
    
	public Boolean getWeight() {
		return weight;
	}

	public void setWeight(Boolean weight) {
		this.weight = weight;
	}

	public void save() {
    	FacesMessage msg;
    	
    	if(name.length()==0){
    		msg = new FacesMessage("Debe ingresar un nombre.");
            FacesContext.getCurrentInstance().addMessage(null, msg);
    		return;
    	}
    	
    	Profile profile = new Profile();
    	profile.setName(name);
    	profile.setGranurality(granularity);
    	profile.setIsWeightedFlag(weight);
    	    	
    	try{
            pDao.create(profile, dualListMetrics.getTarget());
            
    		msg = new FacesMessage("El Perfil fue creado correctamente.");
            FacesContext.getCurrentInstance().addMessage(null, msg);    		
    	} catch(DAOException e) {
    		e.printStackTrace();
    		msg = new FacesMessage("Error al crear el Perfil.");
            FacesContext.getCurrentInstance().addMessage(null, msg);       		
    	}
	}
	
	public void selectOneMenuListener(ValueChangeEvent event) {
	    String granularitySelected = (String) event.getNewValue();
	    filter(granularitySelected);
	}
	
	
	public void filter(String granularitySelected) {
		System.out.println("filter.." + granularitySelected);
		
		String granularityFilter = "Servicio";
		if(granularitySelected.equalsIgnoreCase("Capa")){
			granularityFilter = "Capa";
		} 
		
		List<Metric> list = new ArrayList<>();
	    for(Metric m:listMetrics){
			if(m.getGranurality().equals(granularityFilter)){
				list.add(m);
			}
		}
	    
	    dualListMetrics = new DualListModel<>(new ArrayList<>(list), new ArrayList<Metric>());
	}
}
