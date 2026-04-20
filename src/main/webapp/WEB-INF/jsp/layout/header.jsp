<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="bo-header">
    <div class="brand">
        <img src="<c:url value='/img/logo_menu.png' />" alt="Visa Madagascar Logo" class="brand-logo">
        <div>
            <div class="brand-title">${headerTitle}</div>
            <div class="brand-subtitle">${headerSubtitle}</div>
        </div>
    </div>
    <div class="bo-header-actions">
        <span class="status-chip"><span class="status-dot"></span>En ligne</span>
        <c:if test="${showBack}">
            <a class="back-link" href="${backHref}">${backLabel}</a>
        </c:if>
        <!-- <c:if test="${!showBack}">
            <span class="user-chip">${userLabel}</span>
        </c:if> -->
    </div>
</header>
