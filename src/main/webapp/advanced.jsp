<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<%@ page
    session="true"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"

    import="java.io.File"
    import="java.net.URLDecoder"
    import="java.util.Calendar"
    import="java.util.Date"
    import="java.util.GregorianCalendar"
    import="java.util.regex.Pattern"
    import="java.util.regex.Matcher"
%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ include file="/include/logging_params.jsp" %>
<%@ include file="/include/i18n.jsp" %>
<%@ include file="/include/simple-params-processing.jsp" %>
<fmt:setLocale value="<%=language%>"/>

<%!    //To please the compiler since logging need those -- check [search.jsp]
    private static int hitsTotal = -10;        // the value -10 will be used to mark as being "advanced search"
%>

<%---------------------- Start of HTML ---------------------------%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<c:out value='${locale}' />" lang="<c:out value='${locale}' />">
<head>
    <title><fmt:message key='advanced.meta.title'/></title>
    <meta name="Keywords" content="<fmt:message key='advanced.meta.keywords'/>" />
    <meta name="Description" content="<fmt:message key='advanced.meta.description'/>" />

    <jsp:include page="/include/headerDefault.jsp" />
    <%@ include file="/include/dates.jsp" %>

</head>
<body id="advanced">
    <%@ include file="/include/topbar.jsp" %>
    <div>
    <div class="container-fluid topcontainer col-sm-offset-1 col-sm-10 col-md-offset-2 col-md-8 col-lg-offset-3 col-lg-6 col-xl-offset-4 col-xl-4 " id="headerSearchDiv" >
        <div id="info-texto-termos" class="row">
        </div>
        <!-- Formulario -->
        <div id="main" class="main-form-advanced">
            <div id="conteudo-pesquisa">
                <script type="text/javascript">
                  document.write('<ion-datetime id="ionDateStart" class="display-none" display-format="D/MMM/YYYY" min="'+minYear+'-01-01" max="'+maxYear+'-12-31" value="<%=dateStartStringIonic%>"></ion-datetime>');
                  document.write('<ion-datetime id="ionDateEnd" class="display-none" display-format="D/MMM/YYYY" min="'+minYear+'-01-01" max="'+maxYear+'-12-31" value="<%=dateEndStringIonic%>"></ion-datetime>');
                </script>
                <form  id="searchForm" method="get" action="search.jsp">
                    <input type="hidden" name="l" value="<%= language %>" />
                    <div class="expandable-div">
                        <fieldset id="words">
                            <legend><fmt:message key='advanced.terms'/><i class="fa iCarret yearCarret fa-caret-down pull-right right-15" aria-hidden="true"></i></legend>
                            <div class="box-content container-fluid">
                                <div id="label-palavras-1">
                                    <label for="adv_and" class="row  col-xs-12 no-padding-left label-padding-top"><fmt:message key='advanced.terms.all'/></label>
                                    <div class="withTip ">
                                        <input type="text" id="adv_and" class="row  col-xs-10" name="adv_and" value="<%= (request.getParameter("adv_and") != null && !(request.getParameter("adv_and").equals(""))) ? request.getParameter("adv_and") : and.toString()%>" />
                                        <div class="row  col-xs-10 no-padding-left">
                                            <span class="tip"><fmt:message key='advanced.terms.all.hint'/></span>
                                        </div>
                                    </div>
                                </div>

                                <div id="label-palavras-2">
                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="adv_phr"><fmt:message key='advanced.terms.phrase'/></label>
                                    <div class="withTip">
                                        <input type="text" class="row  col-xs-10" id="adv_phr" name="adv_phr" value="<%= (request.getParameter("adv_phr") != null && !(request.getParameter("adv_phr").equals(""))) ? request.getParameter("adv_phr") : phrase.toString()%>" />
                                        <div class="row  col-xs-10 no-padding-left">
                                            <span class="tip"><fmt:message key='advanced.terms.phrase.hint'/></span>
                                        </div>
                                    </div>
                                </div>

                                <div id="label-palavras-3">
                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="adv_not"><fmt:message key='advanced.terms.not'/></label>
                                    <div class="withTip">
                                        <input type="text" class="row  col-xs-10" id="adv_not" name="adv_not" value="<%= (request.getParameter("adv_not") != null && !(request.getParameter("adv_not").equals(""))) ? request.getParameter("adv_not") : not.toString()%>" />
                                        <div class="row  col-xs-10 no-padding-left">
                                            <span class="tip"><fmt:message key='advanced.terms.not.hint'/></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <div class="expandable-div">
                        <fieldset id="date">
                            <legend><fmt:message key='advanced.date'/><i class="fa iCarret yearCarret fa-caret-down pull-right right-15" aria-hidden="true"></i></legend>
                            <div class="box-content container-fluid">
                                <div id="label-data-1">

                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="dateStart_top"><fmt:message key='advanced.date.from'/></label>
                                    <div class="withTip">
                                        <input size="10" class="row  date-advanced no-padding-left" type="text" id="dateStart_top" name="dateStart" value="<%=dateStartString%>" /><a class="calendar-anchor-advanced" id="startDateCalendarAnchor"><img src="/img/calendario-drop-down.svg"/></a>
                                    </div>
                                    <label id="labelDateEnd" class="row  col-xs-12 no-padding-left label-padding-top" for="dateEnd_top"><fmt:message key='advanced.date.to'/></label>
                                    <div class="withTip">
                                        <input type="text" class="row  date-advanced no-padding-left" id="dateEnd_top" name="dateEnd" size="10" value="<%=dateEndString%>" /><a class="calendar-anchor-advanced" id="endDateCalendarAnchor"><img src="/img/calendario-drop-down.svg"/></a>
                                    </div>
                                </div>

                            </div>
                        </fieldset>
                    </div>
                    <div class="expandable-div">
                        <fieldset id="format">
                            <legend><fmt:message key='advanced.format'/><i class="fa iCarret yearCarret fa-caret-down pull-right right-15" aria-hidden="true"></i></legend>
                            <div class="box-content container-fluid ">
                                <div id="label-format-1">
                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="formatType"><fmt:message key='advanced.format.label'/></label>
                                    <ion-select id="formatType" name="format" interface="action-sheet" placeholder="Select One"  class="row  col-xs-10 no-padding-left formatTypeDropdown">
                                    <%
                                        String[] mimeList = {"pdf", "ps", "html", "xls", "ppt", "doc", "rtf"};
                                        String[] mimeListDetail = {"Adobe PDF (.pdf)", "Adobe PostScript (.ps)", "HTML (.htm, .html)", "Microsoft Excel (.xls)", "Microsoft PowerPoint (.ppt)", "Microsoft Word (.doc)", "Rich Text Format (.rtf)"};

                                        if (format == null || "all".equals(format)) {%>
                                            <ion-select-option value="all" selected><fmt:message key='advanced.format.all'/></ion-select-option>
                                        <%} else {%>
                                            <ion-select-option value="all"><fmt:message key='advanced.format.all'/></ion-select-option>
                                        <%}

                                        for (int i=0; i < mimeList.length; i++) {
                                            if (mimeList[i].trim().equals(format.trim())) {
                                                out.print("<ion-select-option value=\""+ mimeList[i] +"\" selected>"+ mimeListDetail[i] +"</ion-select-option>");
                                            } else {
                                                out.print("<ion-select-option value=\""+ mimeList[i] +"\">"+ mimeListDetail[i] +"</ion-select-option>");
                                            }
                                        }
                                    %>
                                    </ion-select>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <div class="expandable-div">
                        <fieldset id="domains">
                            <legend><fmt:message key='advanced.website'/><i class="fa iCarret yearCarret fa-caret-down pull-right right-15" aria-hidden="true"></i></legend>
                            <div class="box-content container-fluid ">
                                <div id="label-domains-1">
                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="site"><fmt:message key='advanced.website.label'/></label>
                                    <div class="withTip">
                                        <input class="row  col-xs-10 no-padding-left" type="text" id="site" name="site" value="<%=site%>" />
                                        <span class="row  col-xs-10 no-padding-left tip"><fmt:message key='advanced.website.hint'/></span>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <div class="expandable-div">
                        <fieldset id="num_result_fieldset">
                            <legend><fmt:message key='advanced.results'/><i class="fa iCarret yearCarret fa-caret-down pull-right right-15" aria-hidden="true"></i></legend>
                            <div class="box-content container-fluid ">
                                <div id="label-num-result-fieldset-1">
                                    <label class="row  col-xs-12 no-padding-left label-padding-top" for="num-result"><fmt:message key='advanced.results.label'/></label>
                                    <div>
                                        <ion-select id="num-result" interface="action-sheet" placeholder="Select One"  class="row  col-xs-10 no-padding-left formatTypeDropdown" id="num-result" name="hitsPerPage">
                                        <%
                                        int[] hitsPerPageValues = {10, 20, 30, 50, 100};
                                        for (int i=0; i < hitsPerPageValues.length; i++) {
                                            if (hitsPerPage == hitsPerPageValues[i]) {
                                                out.print("<ion-select-option selected>"+ hitsPerPageValues[i] +"</ion-select-option>");
                                            } else {
                                                out.print("<ion-select-option>"+ hitsPerPageValues[i] +"</ion-select-option>");
                                            }
                                        }%>
                                        </ion-select >
                                    </div>
                                    <label class="row  col-xs-12 no-padding-left"><fmt:message key='advanced.results.label2'/></label>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <div id="bottom-submit" class="text-center button-advanced">
                        <button type="submit" value="<fmt:message key='advanced.submit'/>" alt="<fmt:message key='advanced.submit'/>" class="myButtonStyle col-xs-offset-3 col-xs-6" name="btnSubmitBottom" id="btnSubmitBottom" accesskey="e" >
                        <fmt:message key='advanced.search'/>
                        <span class="glyphicon glyphicon-search padding-left-5"></span>
                        </button>
                    </div>


                </form>
                        </div>
                </div>
        <!-- Fim formulário -->
    </div>
</div>

<script type="text/javascript">
window.onload = function() {
	$(".expandable-div legend").click(function() {
	    var isVisible =  $(this).next().is(':visible');
	    if (isVisible){
	        // close
	        $(this).next().slideUp('fast');
	        $(this).children("i").removeClass('fa-caret-down').addClass('fa-caret-up');
	    } else {
	        // open
	        $(this).next().slideDown('fast').show().slideDown('fast');
	        $(this).children("i").removeClass('fa-caret-up').addClass('fa-caret-down');
	    }
	});

	const mobile = ARQUIVO.isMobileOrTablet();
	if (mobile) { // is mobile or tablet
	    $('#dateStart_top').click( function(e) {
	      e.preventDefault();
	      $('#ionDateStart').trigger('click');
	    });
	    $('#dateEnd_top').click( function(e) {
	      e.preventDefault();
	      $('#ionDateEnd').trigger('click');
	    });
	    $('#ionDateStart').on("ionChange", function() {
	        var newStartDate = $('#ionDateStart').val();
	        var newStartDateTokens = newStartDate.split('-');
	        var newStartDateFormated =  newStartDateTokens[2].split('T')[0] + "/" + newStartDateTokens[1]+ "/"+ newStartDateTokens[0];
	        /*ionic uses the date format 1996-01-31T00:00:00+01:00  , we need to convert the date to our own date format i.e.  31/01/1996 */
	        $('#dateStart_top').val(newStartDateFormated);
	    });
	    $('#ionDateEnd').on("ionChange", function() {
	        var newEndDate = $('#ionDateEnd').val();
	        var newEndDateTokens = newEndDate.split('-');
	        var newEndDateFormated =  newEndDateTokens[2].split('T')[0] + "/" + newEndDateTokens[1]+ "/"+ newEndDateTokens[0];
	        /*ionic uses the date format 1996-01-31T00:00:00+01:00  , we need to convert the date to our own date format i.e.  31/01/1996 */
	        $('#dateEnd_top').val(newEndDateFormated);
	    });
	    
	} else {
		const datepickerConfiguration = {
          dateFormat: "dd/mm/yy",
          changeMonth: true, // Whether the month should be rendered as a dropdown instead of text.
          changeYear: true, // Whether the year should be rendered as a dropdown instead of text
          yearRange: minYear+":"+maxYear, // The range of years displayed in the year drop-down - minYear and maxYear are a global javascript variables
          minDate: minDate, // The minimum selectable date - minDate is a global javascript variable
          maxDate: maxDate, // The maximum selectable date - maxDate is a global javascript variable
        };
		ARQUIVO.inputMaskAnInput($('#dateStart_top').datepicker(datepickerConfiguration));
		ARQUIVO.inputMaskAnInput($('#dateEnd_top').datepicker(datepickerConfiguration));
	}

	$('#startDateCalendarAnchor').click( function(e) {
      e.preventDefault();
      $('#dateStart_top').trigger( mobile ? 'click' : 'focus' );
    });
    $('#endDateCalendarAnchor').click( function(e) {
      e.preventDefault();
      $('#dateEnd_top').trigger( mobile ? 'click' : 'focus' );
    });

    /** Validade dates**/
     $( '#searchForm' ).submit( function( ) {
        var dateStartInput = $( '#dateStart_top' ).val().trim();
        var dateEndInput = $( '#dateEnd_top' ).val().trim();
        var startTime = new Date( createDateJsFormat( dateStartInput ) );
        startTime.setHours(0,0,0,0);
        var endTime = new Date( createDateJsFormat( dateEndInput ) );
        endTime.setHours(0,0,0,0);

        if(startTime > endTime) {
          modalErrorDates();
          return false;
        }

        return true;
    });

    function createDateJsFormat( _date ){
        var day = _date.split('/')[0];
        var month = _date.split('/')[1];
        var year = _date.split('/')[2];

        return month + '/' + day + '/' + year;
    }

    function modalErrorDates(){
        uglipop({
          class:'modalReplay noprint', //styling class for Modal
          source:'html',
          content:'<h4 class="modalTitle"><i class="fa" aria-hidden="true"></i> <fmt:message key='datepicker.error.date'/></h4>'+
                  '<div class="row"><a id="errorDates" onclick="closeModalErrorDates()" class="col-xs-6 text-center leftAnchor modalOptions">OK</a></div>'});
    }

    function closeModalErrorDates() {
        $('#uglipop_content_fixed').fadeOut();
        $('#uglipop_overlay').fadeOut('fast');
    }

	monthShortNamesArray = ["<fmt:message key='smonth.0'/>",'<fmt:message key='smonth.1'/>','<fmt:message key='smonth.2'/>','<fmt:message key='smonth.3'/>','<fmt:message key='smonth.4'/>','<fmt:message key='smonth.5'/>','<fmt:message key='smonth.6'/>','<fmt:message key='smonth.7'/>','<fmt:message key='smonth.8'/>','<fmt:message key='smonth.9'/>','<fmt:message key='smonth.10'/>','<fmt:message key='smonth.11'/>'];
	function removeZeroInDay(dayStr){
		if(dayStr.length == 2 && dayStr.charAt(0) === "0"){
		  return dayStr.charAt(1);
		}
		return dayStr;
	}
	function getMonthShortName(monthPositionStr){
		return monthShortNamesArray[parseInt(monthPositionStr)-1];
	}

	$('#ionDateStart')[0].cancelText = "<fmt:message key='picker.cancel'/>";
	$('#ionDateEnd')[0].cancelText = "<fmt:message key='picker.cancel'/>";
	$('#ionDateStart')[0].doneText = "<fmt:message key='picker.ok'/>";
	$('#ionDateEnd')[0].doneText = "<fmt:message key='picker.ok'/>";
	$('#ionDateStart')[0].monthShortNames = monthShortNamesArray;
	$('#ionDateEnd')[0].monthShortNames = monthShortNamesArray;
	$('#formatType')[0].cancelText =  "<fmt:message key='picker.cancel'/>";
	$('#num-result')[0].cancelText =  "<fmt:message key='picker.cancel'/>";

};
</script>

<%@ include file="/include/footer.jsp" %>
<%@include file="/include/analytics.jsp" %>
</body>
</html>

<%@include file="/include/logging.jsp" %>
