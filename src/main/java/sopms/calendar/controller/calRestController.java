package sopms.calendar.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import sopms.calendar.service.calendarService;
import sopms.vo.Calendar;
import sopms.vo.User;

@RestController
public class calRestController {
	@Autowired
	private calendarService service;
	@RequestMapping("calList.do")
	public List<Calendar> calList(HttpServletRequest request, Model d, Calendar calendar){
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute("user");
		calendar.setManager(user.getName());
		return service.calList(calendar);
	}
	@RequestMapping("calendarInsert.do")
	public String calendarInsert(HttpServletRequest request, Calendar insert) {
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute("user");
		insert.setManager(user.getName());
		service.insertCalendar(insert);
		return "등록완료";
	}
	@RequestMapping("calendarUpdate.do")
	public String calendarUpdate(Calendar upt) {
		service.uptCalendar(upt);
		return "수정완료";
	}
	@RequestMapping("calendarDelete.do")
	public String calendarDelete(@RequestParam("id") int id) {
		service.delCalendar(id);
		return "삭제완료";
	}
}
