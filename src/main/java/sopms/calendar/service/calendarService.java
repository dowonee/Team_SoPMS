package sopms.calendar.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import sopms.calendar.dao.calendarDao;
import sopms.vo.CalList;
import sopms.vo.CalListSch;
import sopms.vo.CalStatusCnt;
import sopms.vo.Calendar;
import sopms.vo.User;

@Service
public class calendarService {
	@Autowired
	private calendarDao dao;
	public List<Calendar> calList(Calendar calendar){
		return dao.calList(calendar);
	}

	/*
	public String calList2(Calendar calendar){
		ArrayList<Calendar> list = dao.calList(calendar);
		ArrayList<Calendar> list2 = dao.calList2(calendar);
		for(Calendar cl: list2) {
			cl.setBackgroundColor("#0099cc");
			cl.setBorderColor("#0099cc");
			cl.setTextColor("#ccffff");
		}
		JsonObject dl = new JsonObject();
		Gson gs = new Gson();
		dl.addProperty("list", gs.toJson(list));
		dl.addProperty("list2", gs.toJson(list2));
		String result = gs.toJson(dl);
		System.out.println(result);
		
		return result.replace("\\", "");
	}
	*/
	public void insertCalendar(Calendar insert) {
		dao.insertCalendar(insert);
	}
	public void uptCalendar(Calendar upt) {
		dao.updateCalendar(upt);
	}
	public void delCalendar(int id) {
		dao.deleteCalendar(id);
	}
	public String calStatusCntJson(User user) {
	    Gson gson = new Gson();
	      
	    ArrayList<CalStatusCnt> statusArr = null;
	    System.out.println("직급:"+user.getRank());
	    if(user.getRank().equals("부장")) {
	       CalListSch ss = new CalListSch();
	       ss.setManager(user.getId());
	       ss.setWorkcode(2);
	       statusArr = dao.calStatusCntAll(ss);
	    }else {         
	       statusArr = dao.calStatusCnt(user.getId());
	    }
	      
	    for(CalStatusCnt cs:statusArr) {
			if(cs.getStatus().equals("종료됨")) {
				cs.setStatus("완료");
			} else if(cs.getStatus().equals("승인요청")) {
				cs.setStatus("미진행");;
			}
		}
	    	    
	    return gson.toJson(statusArr);
	}
	public String calListAll(CalListSch cal) {
		Gson gson = new Gson();
	      
	    ArrayList<CalList> arr = null;
		cal.setCount(dao.calCount(cal));
		if(cal.getPageSize() == 0) {
			cal.setPageSize(5);
		}
		cal.setPageCount((int) Math.ceil(cal.getCount() / (double) cal.getPageSize()));
		if(cal.getCurPage() == 0) {
			cal.setCurPage(1);
		}
		if(cal.getCurPage() > cal.getPageCount()) {
			cal.setCurPage(cal.getPageCount());
		}
		cal.setStart((cal.getCurPage()-1) * cal.getPageSize() + 1);
		cal.setEnd(cal.getCurPage() * cal.getPageSize());
		cal.setBlockSize(5);
		int blocknum = (int) (Math.ceil(cal.getCurPage() / (double)cal.getBlockSize()));
		int endBlock = blocknum * cal.getBlockSize();
		
		if(endBlock > cal.getPageCount()) {
			endBlock = cal.getPageCount();
		}
		
		cal.setEndBlock(endBlock);
		cal.setStartBlock((blocknum - 1) * cal.getBlockSize() + 1);
		if(cal.getStartBlock()<0) {
			cal.setStartBlock(1);
		}
		arr = dao.calListAll(cal);
		System.out.println(arr);
		return gson.toJson(arr);
	}
}
