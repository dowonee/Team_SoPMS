<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<fmt:requestEncoding value="utf-8" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>SOPMS</title>
<!-- Favicon icon -->
<link rel="icon" type="image/png" sizes="16x16"
	href="./images/favicon.png">
<link rel="stylesheet"
	href="./vendor/owl-carousel/css/owl.carousel.min.css">
<link rel="stylesheet"
	href="./vendor/owl-carousel/css/owl.theme.default.min.css">
<link href="./vendor/jqvmap/css/jqvmap.min.css" rel="stylesheet">
<!-- fullcalendar -->
<link href="./vendor/fullcalendar/lib/main.css" rel="stylesheet">
<script src="./vendor/fullcalendar/lib/main.js" type="text/javascript"></script>

<link href="./css/style.css" rel="stylesheet">
<script src="https://unpkg.com/vue/dist/vue.js" type="text/javascript"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU"
	crossorigin="anonymous">
</head>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');
		var toDay = new Date().toISOString().split("T")[0];
		var calendar = new FullCalendar.Calendar(calendarEl, {
			headerToolbar : {
				left : 'dayGridMonth,timeGridWeek,timeGridDay',
				center : 'title',
				right : 'prev,next today'
			},
			initialDate : toDay,
			navLinks : true,
			selectable : true,
			selectMirror : true,
			eventLimit : false,
			select : function(arg) {
				$("h2").click();
				$("#exampleModalLongTitle").text("일정등록");
				$("#regBtn").show();
				$("#uptBtn").hide();
				$("#delBtn").hide();
				$(".form-cal").show();
				$("#table-wbs").hide();
				$(".form-cal")[0].reset();
				$("#start").val(arg.start.toLocaleString());
				$("[name=start]").val(arg.start.toISOString());
				$("#end").val(arg.end.toLocaleString());
				$("[name=end]").val(arg.end.toISOString());
				calendar.unselect()
			},
			eventClick : function(arg) {
				$("h2").click();
				$("#exampleModalLongTitle").text("상세일정");
				$("#regBtn").hide();
				$("#uptBtn").show();
				$("#delBtn").show();
				$(".form-cal").show();
				$("#table-wbs").hide();
				$("#parent").children('#1').prop("selected", true);
				
				if(arg.event.extendedProps.process == 0 && arg.event.borderColor == "#6633FF") {
					$("#uptBtn").hide();
					$("#delBtn").hide();
					$(".form-cal").hide();
					$("#table-wbs").show();
					console.log(arg.event.extendedProps.workcode);
				}
				addForm(arg.event);
			},
			eventDrop : function(info) {
				console.log("#이벤트 드랍#")
				console.log(info.event);
				addForm(info.event);
				ajaxFun("calendarUpdate.do")
			},
			eventResize : function(info) {
				console.log("#이벤트 사이즈변경#")
				console.log(info.event);
				addForm(info.event);
				ajaxFun("calendarUpdate.do")
			},
			editable : true,
			dayMaxEvents : false,
			events : function(info, successCallback, failureCallback) {
				$.ajax({
					type : "post",
					url : "${path}/calList.do",
					dataType : "json",
					success : function(data) {
						console.log(data)
						successCallback(data);
					},
					error : function(err) {
						console.log(err);
					}

				});

			}
		});

		calendar.render();

		$("#regBtn").click(function() {
			if ($("[name=title]").val() == "") {
				alert("일정을 등록하세요!");
				return;
			} else if($("[name=borderColor]").val() == ""){
				alert("일정색상을 선택하세요!");
				return;
			} else if($("[name=allDay]").val() == ""){
				alert("종일여부를 선택하세요!");
				return;
			} else if($("[name=process]").val() == ""){
				alert("진행률을 선택하세요!");
				return;
			}
			ajaxFun("calendarInsert.do")
		});
		$("#uptBtn").click(function() {
			if (confirm("수정하시겠습니까?")) {
				if ($("[name=title]").val() == "") {
					alert("일정을 등록하세요!");
					return;
				} else if($("[name=borderColor]").val() == ""){
					alert("일정색상을 선택하세요!");
					return;
				} else if($("[name=allDay]").val() == ""){
					alert("종일여부를 선택하세요!");
					return;
				} else if($("[name=process]").val() == ""){
					alert("진행률을 선택하세요!");
					return;
				}
				ajaxFun("calendarUpdate.do")
			}
		});
		$("#delBtn").click(function() {
			if (confirm("삭제하시겠습니까?")) {
				ajaxFun("calendarDelete.do")
			}
		});

	});
	function ajaxFun(url) {
		$.ajax({
			type : "post",
			url : "${path}/" + url,
			data : $("form").serialize(),
			success : function(data) {
				alert(data);
				console.log($("form").serialize());
				location.reload();
			},
			error : function(err) {
				console.log(err);
				console.log($("form").serialize());
			}

		});
	}
	function addForm(event) {
		if(event.extendedProps.borderColor != "#6633FF" && event.extendedProps.pm == event.extendedProps.manager){
			$(".form-cal")[0].reset();
			$("[name=id]").val(event.id);
			$("[name=workcode]").val(event.extendedProps.workcode);
			console.log(event.extendedProps.process);
			$("#parent").val(event.extendedProps.parent).prop("selected", true);
			$("[name=parent]").val(event.extendedProps.parent);
			$("[name=title]").val(event.title);
			$("#borderColor").val(event.borderColor).prop("selected", true);
			$("[name=borderColor]").val(event.borderColor);
			$("[name=backgroundColor]").val(event.backgroundColor);
			$("[name=textColor]").val(event.textColor);
			$("[name=content]").val(event.extendedProps.content);
			$("#start").val(event.start.toLocaleString());
			$("[name=start]").val(event.start.toISOString());
			console.log($("[name=start]").val());
			$("#end").val(event.end.toLocaleString());
			$("[name=end]").val(event.end.toISOString());
			if(event.allDay){
				$("#all").prop("selected", true);
			}else{
				$("#time").prop("selected", true);
			}
			$("[name=allDay]").val(event.allDay?1:0);
			console.log($("[name=allDay]").val())
			$("#process").val(event.extendedProps.process).prop("selected", true);
			$("[name=process]").val(event.extendedProps.process);
			$("[name=status]").val(event.extendedProps.status);
			}  else {
			// wbs 모달창
			if(event.extendedProps.parent == 2){ $("#project-wbs").text("교육용 모바일웹 앱 프로토타입");}
			else if(event.extendedProps.parent == 3){ $("#project-wbs").text("병원 사내 어플 신규 제작");}
			else if(event.extendedProps.parent == 4){ $("#project-wbs").text("비즈니스 플랫폼 앱 제작");}
			else if(event.extendedProps.parent == 5){ $("#project-wbs").text("비대면의료상담 중개 앱서비스");}
			else if(event.extendedProps.parent == 6){ $("#project-wbs").text("SL솔루션 홈페이지");}
			else if(event.extendedProps.parent == 7){ $("#project-wbs").text("박물관 홈페이지 제작");}
			$("#manager-wbs").text(event.extendedProps.name);
			console.log(event.extendedProps.parent);
			$("#title-wbs").text(event.title);
			$("#content-wbs").text(event.extendedProps.content);
			$("#start-wbs").text(event.start.toLocaleString());
			$("#end-wbs").text(event.end.toLocaleString());
			$("#process-wbs").text(event.extendedProps.status);
		}
	}
</script>
<style>
	#table-wbs table tr th {
	    font-size: 17px;
	    color: black;
	    padding: 10px;
	    width: 20%;
	}
	#table-wbs table tr td {
	    font-size: 17px;
	    color: black;
	    padding-left: 40px;
	    width: 80%;
	}
	#table-wbs table tr {
    height: 4vw;
	}	
</style>
<body hoe-navigation-type="horizontal" hoe-nav-placement="left"
	theme-layout="wide-layout">
	<div id="main-wrapper">
		<jsp:include page="header.jsp" />
		<jsp:include page="navi.jsp" />
		<div class="content-body">

			<div class="card">
				<div class="card-body">
					<div class="container">
						<!-- Page Heading_전체일정 -->
						<div
							class="d-sm-flex align-items-center justify-content-between mb-4">
							<h1 class="h3 mb-0 font-weight-bold text-gray-800">전체 일정</h1>
							<!-- 
							position : absolute 처리
							<form method="post">
								<select id="pjsch" name="pjsch" class="form-select">
									<option value="">전체 일정</option>
								</select>
							</form>
							 -->
							<button type="button" onclick="location.href='${path}/manage_mem.do'"
								class="btn btn-primary">관리 페이지</button>
						</div>
						<!-- 일자 클릭시 메뉴오픈 -->
						<div id="wrapper">
							<div id="calendar"></div>
						</div>
						<!-- 일정 추가 MODAL -->
						<h2 data-toggle="modal" data-target="#exampleModalCenter"></h2>
						<div class="modal fade" id="exampleModalCenter" tabindex="-1"
							role="dialog" aria-labelledby="exampleModalCenterTitle"
							aria-hidden="true">
							<div class="modal-dialog modal-dialog-centered" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="exampleModalLongTitle">타이틀</h5>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">
										<!-- 일반 등록창 -->
										<form class="form-cal" method="post">
											<input type="hidden" name="id" value="0" />
											<div class="input-group mb-3" id="parent_select">
												<div class="input-group-prepend">
													<span class="input-group-text">프로젝트명</span>
												</div>
												<select id="parent" class="form-control"
													onchange="parentChange(this.value);">
													<option id="1">일정을 등록할 프로젝트를 선택해주세요</option>
													<option value=2 id="2">교육용 모바일웹 앱 프로토타입</option>
													<option value=3 id="3">병원 사내 어플 신규 제작</option>
													<option value=4 id="4">비즈니스 플랫폼 앱 제작</option>
													<option value=5 id="5">비대면의료상담 중개 앱서비스</option>
													<option value=6 id="6">SL솔루션 홈페이지</option>
													<option value=7 id="7">박물관 홈페이지 제작</option>
												</select> <input type="hidden" name="parent" />
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">일정</span>
												</div>
												<input type="text" name="title" class="form-control"
													placeholder="일정입력"> 
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">시작일</span>
												</div>
												<input type="text" id="start" class="form-control"
													placeholder="입력" onchange="startChange(this.value)"> <input type="hidden" name="start"/>
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">종료일</span>
												</div>
												<input type="text" id="end" class="form-control"
													placeholder="입력" onchange="endChange(this.value)"> <input type="hidden" name="end"/>
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">내용</span>
												</div>
												<textarea name="content" rows="5" cols="10"
													class="form-control"></textarea>
											</div>
											<div class="input-group mb-3" id="borderColor_select">
												<div class="input-group-prepend">
													<span class="input-group-text">일정색상</span>
												</div>
												<select id="borderColor" class="form-control"
													onchange="colorChange(this.value);">
													<option>색상을 선택해주세요</option>
													<option value="#F44336" style="color:#F44336;">빨간색</option>
													<option value="#F57C00" style="color:#F57C00;">주황색</option>
													<option value="#FFD700" style="color:#FFD700;">노란색</option>
													<option value="#2E7D32" style="color:#2E7D32;">초록색</option>
													<option value="#0099cc" style="color:#0099cc;">하늘색</option>
													<option value="#000000" style="color:#000000;">검은색</option>
												</select>
												<input type="hidden" name="borderColor">
												<input type="hidden" name="backgroundColor">
												<input type="hidden" name="textColor">
												<input type="hidden" name="status">
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">종일여부</span>
												</div>
												<select id="allDay" class="form-control"
													onchange="allDayChange(this.value);">
													<option>종일여부를 선택해주세요</option>
													<option value="true" id="all">종일</option>
													<option value="false" id="time">시간</option>
												</select> <input type="hidden" name="allDay" />
											</div>
											<div class="input-group mb-3">
												<div class="input-group-prepend">
													<span class="input-group-text">진행률</span>
												</div>
												<select id="process" class="form-control"
													onchange="processChange(this.value);">
													<option>진행률을 선택해주세요</option>
													<c:forEach var="i" begin="0" end="100">
														<option value="${i}">${i}%</option>
													</c:forEach>
												</select> <input type="hidden" name="process" />
											</div>
										</form>
										<!-- wbs 모달창 -->
										<div id="table-wbs">
												<table height="100%">
													<tr><th>등록자명</th><td id="manager-wbs"></td></tr>
													<tr><th>일정</th><td id="title-wbs"></td></tr>
													<tr><th>시작일</th><td id="start-wbs"></td></tr>
													<tr><th>종료일</th><td id="end-wbs"></td></tr>
													<tr><th>내용</th><td id="content-wbs"></td></tr>
													<tr><th>진행률</th><td id="process-wbs"></td></tr>
												</table>
										</div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary"
											data-dismiss="modal">Close</button>
											<button type="button" id='regBtn' class="btn btn-primary">등록</button>
											<button type="button" id='uptBtn' class="btn btn-info">수정</button>
											<button type="button" id='delBtn' class="btn btn-warning">삭제</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- /.container -->
				</div>
			</div>
		</div>
		<jsp:include page="footer.jsp" />
	</div>
</body>
<script>
	var allDayChange = function(value) {
		if(value == "true"){
			$("[name=allDay]").val(1);
		}else{
			$("[name=allDay]").val(0);
		}
		if($("[name=allDay]").val() == 1){
			$("[name=borderColor]").val($("#borderColor option:selected").val());
			$("[name=backgroundColor]").val($("#borderColor option:selected").val());
			$("[name=textColor]").val("#FFFFFF");
		}else {
			$("[name=borderColor]").val($("#borderColor option:selected").val());
			$("[name=backgroundColor]").val("#FFFFFF");
			$("[name=textColor]").val($("#borderColor option:selected").val());
		}
		console.log($("[name=allDay]").val());
	}
	var colorChange = function(value) {
		$("[name=borderColor]").val(value);
		$("[name=backgroundColor]").val("#FFFFFF");
		$("[name=textColor]").val(value);
		console.log($("[name=textColor]").val());
	}
	var processChange = function(value) {
		console.log(value);
		$("[name=process]").val(value);
		if(value==0){
			$("[name=status]").val("승인요청")
		}else if(value>0&&value<100){
			$("[name=status]").val("진행중")
		}else{
			$("[name=status]").val("종료됨")
		}
		console.log($("[name=status]").val());
	}
	var startChange = function(value) {
		$("[name=start]").val(value.toISOString());
		console.log($(value));
	}
	var endChange = function(value) {
		$("[name=end]").val(value.toISOString());
		console.log($("[name=end]").val());
	}
	var parentChange = function(value) {
		$("[name=parent]").val(value);
	}
</script>

<!-- Required vendors -->
<script src="./vendor/global/global.min.js"></script>
<script src="./js/quixnav-init.js"></script>
<script src="./js/custom.min.js"></script>


<!-- Vectormap -->
<script src="./vendor/raphael/raphael.min.js"></script>
<script src="./vendor/morris/morris.min.js"></script>


<script src="./vendor/circle-progress/circle-progress.min.js"></script>
<script src="./vendor/chart.js/Chart.bundle.min.js"></script>

<script src="./vendor/gaugeJS/dist/gauge.min.js"></script>

<!--  flot-chart js -->
<script src="./vendor/flot/jquery.flot.js"></script>
<script src="./vendor/flot/jquery.flot.resize.js"></script>

<!-- Owl Carousel -->
<script src="./vendor/owl-carousel/js/owl.carousel.min.js"></script>

<!-- Counter Up -->
<script src="./vendor/jqvmap/js/jquery.vmap.min.js"></script>
<script src="./vendor/jqvmap/js/jquery.vmap.usa.js"></script>
<script src="./vendor/jquery.counterup/jquery.counterup.min.js"></script>

<script src="./js/dashboard/dashboard-1.js"></script>
<script type="text/javascript">
	
</script>
</html>