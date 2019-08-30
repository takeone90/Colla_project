<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">

function (startDateStr, endDateStr) {
	//시작 년 월 일
	var startDateStrDate = new Date(startDateStr);
	var startDateYMD = startDateStr.substring(0, 10); //2019-08-30
	var startDateYear = startDateStr.substring(0, 4);
	var startDateMonth = startDateStr.substring(5, 7);
	var startDateDate = startDateStr.substring(8, 10);
	var startDateNumber = startDateYear+startDateMonth+startDateDate; //20190830
	//종료 년 월 일
	var endDateStrDate = new Date(endDateStr);
	var endDateYMD = endDateStr.substring(0, 10);
	var endDateYear = endDateStr.substring(0, 4);
	var endDateMonth = endDateStr.substring(5, 7);
	var endDateDate = endDateStr.substring(8, 10);	
	
	var gap = Number(endDateStrDate.getTime()-startDateStrDate.getTime())/(1000*60*60*24)+Number(1); //시작일~종료일 기간 구하기
	
	var firstDateOfThisSchedule = new Date(startDateYear, startDateMonth-1, 1); //해당 일정이 있는 월의 첫날 구하기
	var firstDayOfThisSchedule = firstDateOfThisSchedule.getDay(); //첫날 요일 구하기
	
	var weekCountOfThisSchedule = Math.ceil((Number(firstDayOfThisSchedule)+Number(startDateDate))/7); //해당 날짜가 몇 번째 주인지 구하기(0~5)	
	var trClassWhereIWantToAppend = startDateYear+startDateMonth+(Number(weekCountOfThisSchedule)-1); //tr 클래스		
}



function trMaker1(startDayOfThisSchedule, endDayOfThisSchedule, gap, title) {
	var tr = $("<tr height=\"20\">");
	//일정 앞에 td 붙이기
	for(var l=0; l<startDayOfThisSchedule; l++) { //tdEtc 반복해서 붙이기
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: #fff2f6\"></td>");
		tr.append(tdEtc);
		console.log("앞 : "+l);
	}
	
	//일정 붙이기
	var td = $("<td colspan="+gap+"; style=\"margin-bottom: 1pt; margin-top: 1pt; border-radius: 10px; background-color: "+randomColor()+"\">"+title+"</td>");
	tr.append(td);
	
	//일정 뒤에 td 붙이기
	var numberOfTdEtc = Number(6)-Number(endDayOfThisSchedule); //뒤에 tdEtc를 몇개 붙여야하는가?
	console.log("numberOfTdEtc : "+numberOfTdEtc);
	for(var l=0; l<numberOfTdEtc; l++) { //tdEtc 반복해서 붙이기
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: #fff2f6\"></td>");
		tr.append(tdEtc);
		console.log("뒤 : "+l);
	}
	return tr;
}

function trMaker2(startDayOfThisSchedule, endDayOfThisSchedule, gap, title) {
	var tr = $("<tr height=\"20\">");
	//일정 앞에 td 붙이기
	for(var l=0; l<startDayOfThisSchedule; l++) { //tdEtc 반복해서 붙이기
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: #fff2f6\"></td>");
		tr.append(tdEtc);
		console.log("앞 : "+l);
	}
	
	//일정 붙이기
	var td = $("<td colspan="+gap+"; style=\"margin-bottom: 1pt; margin-top: 1pt; border-radius: 10px; background-color: "+randomColor()+"\">"+title+"</td>");
	tr.append(td);
	return tr;
}

function trMaker3(startDayOfThisSchedule, endDayOfThisSchedule, gap, title) {
	var tr = $("<tr height=\"20\">");

	//일정 붙이기
	var td = $("<td colspan="+gap+"; style=\"margin-bottom: 1pt; margin-top: 1pt; border-radius: 10px; background-color: "+randomColor()+"\">"+title+"</td>");
	tr.append(td);
	
	//일정 뒤에 td 붙이기
	var numberOfTdEtc = Number(6)-Number(endDayOfThisSchedule); //뒤에 tdEtc를 몇개 붙여야하는가?
	console.log("numberOfTdEtc : "+numberOfTdEtc);
	for(var l=0; l<numberOfTdEtc; l++) { //tdEtc 반복해서 붙이기
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: #fff2f6\"></td>");
		tr.append(tdEtc);
		console.log("뒤 : "+l);
	}
	return tr;
}

</script>

</head>
<body>
<div>
	<table border='1' style="border-collapse: collapse;">
		<tr height="20" style="border-radius: 2px;">
			<th width="">1</th>
			<th onclick="">2</th>
			<th>3</th>
			<th>4</th>
			<th>5</th>
			<th>6</th>
			<th colspan="1" >7</th>
			<td class="tdClass" bordercolor="white"></td>
		</tr>
		<tr style="text-align: left">일정</tr>
		<tr class=""></tr>
		<tr></tr>
		
	</table>
</div>
</body>
</html>

<!-- today.getFullYear()+month+k -->

// 			for(var j=0; j<7; j++) {
// 				if(j<firstDayOfWeek && i==0 || dateCount>lastDayDate) {
// 					calendar += "<td style=\"padding: 0px; height: 20px; position: relative; background-color: #fcedf2\"></td>";
// 				} else {
// 					if(dateCount<10) {
// 						calendar += "<td style=\"padding: 0px; height: 20px; position: relative; background-color: #fcedf2\" id="+today.getFullYear()+month+"0"+dateCount+(k+1)+"></td>";
// 					} else {
// 						calendar += "<td style=\"padding: 0px; height: 20px; position: relative; background-color: #fcedf2\" id="+today.getFullYear()+month+dateCount+(k+1)+"></td>";
// 					}
// 				}
// 			}

// 				var title = allCalendar[i].title;
				
// 				var startDate = allCalendar[i].startDate;
// 				var year = startDate.substring(0, 4);
// 				var month = startDate.substring(5, 7);
// 				var date = startDate.substring(8, 10);
// 				var firstDayTmp = new Date(year, month-1, 1); //첫날 구하기
// 				var firstDayOfWeek = firstDayTmp.getDay(); //첫날 요일 구하기
// 				var weekCountTmp = Math.ceil((Number(firstDayOfWeek)+Number(date))/7); //해당 날짜가 몇 번째 주인지 구하기(0~5)
				
// 				var startDateStr = new Date(allCalendar[i].startDate);
// 				var endDateStr = new Date(allCalendar[i].endDate);
// 				var gap = Number(endDateStr.getTime()-startDateStr.getTime())/(1000*60*60*24)+Number(1); //시작일~종료일 기간 구하기
// 				console.log("gap between startDate and endDate : "+gap);
				
// 				var td = $("<td colspan="+gap+"; style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: "+randomColor()+"\">"+title+"</td>");
				
