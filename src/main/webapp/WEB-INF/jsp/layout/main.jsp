<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" default="Visa Backoffice" /></title>
    <link rel="icon" type="image/png" href="<c:url value='/img/logo-removebg.png' />">

    <link rel="stylesheet" href="<c:url value='/webjars/bootstrap/5.3.3/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&display=swap">
    <link rel="stylesheet" href="<c:url value='/webjars/font-awesome/6.4.0/css/all.min.css' />">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="<c:url value='/css/style.css' />">
</head>
<body>
<div class="bo-layout">
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

    <main class="bo-main">
        <div class="bo-content">
            <jsp:include page="${contentPage}" />
        </div>
    </main>

    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
</div>

<script src="<c:url value='/webjars/jquery/3.7.1/jquery.min.js' />"></script>
<script src="<c:url value='/webjars/bootstrap/5.3.3/js/bootstrap.bundle.min.js' />"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
<script src="<c:url value='/js/main.js' />"></script>
</body>
</html>
