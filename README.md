![header](https://capsule-render.vercel.app/api?type=waving&color=auto&height=300&section=header&text=SOPMS&fontSize=90)
---

## ⚡프로젝트 계획
> 프로젝트의 성공적인 성과 및 진행 지표를 체계적으로 관리하기 위한 시스템입니다.
> 프로젝트 진행 현황과 성과물의 체계적인 관리, 시스템화를 통한 프로젝트 관리의 용이성을 확보하여 업무 생산성을 향상시키고 관리효율을 증대시켜 성공적으로 프로젝트를 관리하는 것이 프로젝트의 핵심 목표입니다.
> 작업계획, 리스크 관리, 인적/물적 자원관리, 업무 할당 및 활동지시, 프로젝트 집행 제어, 진전보고, 결과 분석을 포함합니다.

---      
</br>


## ⚡프로젝트 기간
> 2021.09.23 - 2021.10.26

---
</br>


## ⚡주요기능
* 시각화된 프로젝트 현황 조회, 개별 작업현황 조회, 개인일정관리 시스템 등을 통하여 프로젝트 전체의 시간, 인적자원 배분을 최적화
* 프로젝트 진행중의 오류를 최소화하는 리스크관리 솔루션
* 승인제도 및 인원등록 시스템을 통한 보안화된 팀원관리
* 팀원간 원활한 협업 및 소통을 지원하는 채팅 시스템

---
</br>


## ⚡개발환경
* System : Window 10
* Language : Java(JDK - 15), JSP, Ajax, Html5, CSS, JS
* Framework : Spring 5.0, Mybatis 3, Vue.js
* Tools : Github
* Development Tools : Eclipse IDE, eXERD
* DBMS : Oracle DB XE 11g
* WAS : Tomcat 9.0
* Javascript Library : JQuery
* Bootstrap : Bootstrap 5

---
</br>

## ⚡ 페이지구성
> <a href="https://imgbb.com/"><img src="https://i.ibb.co/5nHHwBc/image.jpg" alt="image" border="0"></a>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/NF4WpN0/2.jpg" alt="2" border="0"></a>


---
</br>

## ⚡ ERD
> <a href="https://imgbb.com/"><img src="https://i.ibb.co/jz08v1G/3.jpg" alt="3" border="0"></a>


---
</br>

## ⚡ Permission
> <a href="https://ibb.co/LtFVRPt"><img src="https://i.ibb.co/FwrR3Ww/2.png" alt="2" border="0"></a>
<a href="https://ibb.co/zPs73tK"><img src="https://i.ibb.co/Dw48Bj3/3.png" alt="3" border="0"></a>
### * 권한이 없는 직원이 접근 시
<a href="https://imgbb.com/"><img src="https://i.ibb.co/HHxwwyx/4.png" alt="4" border="0"></a>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/4jknXd3/5.png" alt="5" border="0"></a>
### * 권한을 가진 직원이 접근 시
<a href="https://imgbb.com/"><img src="https://i.ibb.co/m83Wg8c/6.png" alt="6" border="0"></a>


---
</br>

## ⚡ 맡은 기능구현
* 프로젝트 등록
 
><a href="https://imgbb.com/"><img src="https://i.ibb.co/NNYgRQB/7.png" alt="7" border="0"></a>

```
	@RequestMapping(params = "method=updateform")
	public String projectUpdateForm(@RequestParam("pcode") int pcode,HttpServletRequest request, Model d) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		if (!user.getRank().equals("부장")) {
			d.addAttribute("msg", "접근권한이 없습니다.");
			return "forward:/dashboard.do";
		} else {
			d.addAttribute("project", service.getProject(pcode));
			return "WEB-INF\\view\\project_Update.jsp";
		}
	}
```
```
	$("#regBtn").click(function() {
		if (insert01.pname.value == "" || insert01.dept.value == "" ||insert01.startdate.value == "" || insert01.enddate.value == ""|| insert01.teamnum.value == "") {
			alert("필수입력란이 비었습니다. 확인해주세요.");
			return false;
		}
		var startDate = $("input[name=startdate]").val().split("-");
		var endDate  = $("input[name=enddate]").val().split("-");
		var sDate    = new Date(startDate[0], startDate[1], startDate[2]).valueOf();
		var eDate    = new Date(endDate[0], endDate[1], endDate[2]).valueOf();
		if ( sDate > eDate ) {
			alert("시작일과 종료일을 확인해주세요.");
			return false;			
		}
		$("#insert01").submit();
		alert("프로젝트를 등록했습니다.");
	});
```

* 프로젝트 상세

><a href="https://imgbb.com/"><img src="https://i.ibb.co/QJg3bVF/8.png" alt="8" border="0"></a>
```
	function getProjectData() {
		$.ajax({
			type : 'POST',
			url : '${path}/projectSum.do',
			data : 'pcode=${param.pcode}',
			dataType : 'json',
			success : function(data) {
				printData(data);
			},
			error : function(err) {
				alert(err);
			}
		});
	}
```
```
	function printData(data){
		$('#pj_name').text(data.pname);
		$('#pj_pm').text(data.pmName);
		$('#pj_start_date').text(data.startDate);
		$('#pj_end_date').text(data.endDate);
		$('#pj_max_headCnt').text(data.teamNum);
		$('#pj_status').text(data.status);
		$('#pj_explanation').html(data.explanation);
		//부서 목록 출력
		let deptHTML = '';
		data.dept.forEach(function(element,index,array){
			if(index!=0) deptHTML+='<br>';
			deptHTML+=element;
		});
		if($('#pj_pm').text()=='${user.name}') {
			$("#btns").css('display','block');
		}
		$('#pj_dept').html(deptHTML);
	}
```


* 공지사항 수정

><a href="https://imgbb.com/"><img src="https://i.ibb.co/0Gx9HQ6/9.png" alt="9" border="0"></a>
```
<!-- Modal -->
<div class="modal fade" id="exampleModalCenter">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">프로젝트 수정</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p>프로젝트를 수정하시겠습니까?</p>
			</div>
			<div class="modal-footer">
				<button type="button" id="uptBtn_modal" name="uptbtn"
					class="btn btn-primary">확인</button>
				<button type="button" id="canBtn_modal" class="btn btn-light"
					data-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
```

* 프로젝트 정보 권한 별 버튼

><a href="https://imgbb.com/"><img src="https://i.ibb.co/pjTLGKJ/10.png" alt="10" border="0"></a>

* 공지사항 등록 (파일 업로드)

><a href="https://imgbb.com/"><img src="https://i.ibb.co/T815crZ/11.png" alt="11" border="0"></a>
```
	@RequestMapping(params = "method=insert")
	public String boardInsert(HttpServletRequest request, Board board) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		board.setId(user.getId());
		service.insertBoard(board);
		return "redirect:/board.do?method=list";
	}
```
```
<div class="custom-file">
 <input type="file" name="report" class="custom-file-input"
 id="file01"> <label class="custom-file-label"
 for="file01"> 파일을 선택하세요. </label>
</div>
```
* 공지사항 권한 별 버튼

><a href="https://imgbb.com/"><img src="https://i.ibb.co/XzYydcy/12.png" alt="12" border="0"></a>
```
	<c:if test="${user.id == board.id}">
	<button id="upt" class="btn btn-primary" type="button">수정</button>
	<button id="del" data-toggle="modal"
		data-target="#exampleModalCenter2"
		class="btn btn-danger btn-lg btn-block center-block"
		type="button">삭제</button>
	</c:if>
```

* 게시판 목록

><a href="https://imgbb.com/"><img src="https://i.ibb.co/R2SLmvn/13.png" alt="13" border="0"></a>
```
	$("#paging").children("li").click(function() {
		var id = $(this).attr('id');
		if(id=='next'){
			if($('.active').next().attr('id')==id){
				alert("마지막 페이지 입니다");
				return;
			}else{
				$('.active').next().attr('class', 'page-item active');
				$('.active').first().attr('class', 'page-item');
			}
		}else if(id=='pre'){
			if($('.active').prev().attr('id')==id){
				alert("첫 페이지 입니다");
				return;
			}else{
				$('.active').prev().attr('class', 'page-item active');
				$('.active').last().attr('class', 'page-item');
			}
		}else{
			$("#paging").children("li").attr('class', 'page-item');
			$(this).attr('class', 'page-item active');
		}
	});
```
```
<ul class="pagination justify-content-center" id="paging">
<li class="page-item" id="pre"><a class="page-link"
	href="javascript:goBlock(${boardSch.startBlock-1})">Pre</a></li>
<c:forEach var="cnt" begin="${boardSch.startBlock}"
	end="${boardSch.endBlock}">
	<li class="page-item ${boardSch.curPage==cnt?'active':''}"><a
		class="page-link" href="javascript:goPage(${cnt})">${cnt}</a></li>
</c:forEach>
<li class="page-item" id="next"><a class="page-link"
	href="javascript:goBlock(${boardSch.curPage+1})"> Next </a></li>
</ul>
```

* 공지사항 상세보기 (파일 다운로드)

><a href="https://imgbb.com/"><img src="https://i.ibb.co/SmcgDDq/14.png" alt="14" border="0"></a>
```
	@Value("${upload}")
	private String upload;
	@Override
	protected void renderMergedOutputModel(
			Map<String, Object> model, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// TODO Auto-generated method stub
		String bfname = (String)model.get("boardFile");
		File file = new File(upload+bfname);
		System.out.println("전체파일명:"+file.getPath());
		System.out.println("파일명:"+file.getName());
		System.out.println("파일길이:"+(int)file.length());
		response.setContentType("application/download; charset=UTF-8");
		response.setContentLength((int)file.length());
		bfname = URLEncoder.encode(bfname,"utf-8").replaceAll("\\+", " ");
		response.setHeader("Content-Disposition",
				"attachment;filename=\""+bfname+"\"");
		response.setHeader("Content-Transfer-Encoding", "binary");
		FileInputStream fis = new FileInputStream(file);
		OutputStream out = response.getOutputStream();
		FileCopyUtils.copy(fis, out);
		out.flush();
	}
}
```


---
</br>


## ⚡ TEST

### * 단위테스트

><a href="https://ibb.co/19XmVVT"><img src="https://i.ibb.co/vJdj55k/15.png" alt="15" border="0"></a>

### * 통합테스트

><a href="https://ibb.co/2Njh00J"><img src="https://i.ibb.co/SrKyDDS/16.png" alt="16" border="0"></a>



---
</br>



## ⚡ ISSUES
<details markdown="1">
<summary>펼치기</summary>

<a href="https://ibb.co/F0LNmL4"><img src="https://i.ibb.co/Br5dc52/17.png" alt="17" border="0"></a>

</details>
