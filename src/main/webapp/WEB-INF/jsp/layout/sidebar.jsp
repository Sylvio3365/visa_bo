<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="bo-sidebar">
    <div class="sidebar-title">Navigation</div>
    <nav class="bo-nav">
        <a class="${activePage eq 'dashboard' ? 'nav-link active' : 'nav-link'}" href="<c:url value='/'/>">Dashboard</a>
        <details class="nav-group" ${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'open' : ''}>
            <summary class="${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                Types de visa
            </summary>
            <div class="nav-submenu">
                <a class="${activePage eq 'type-visa' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa'/>">Liste</a>
                <a class="${activePage eq 'type-visa-add' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa/ajout'/>">Ajout</a>
            </div>
        </details>
        <a class="nav-link" href="#">Demandes</a>
        <a class="nav-link" href="#">Demandeurs</a>
        <a class="nav-link" href="#">Statuts</a>
    </nav>
    <div class="bo-sidebar-footer">
        <div class="footer-label">Derniere mise a jour</div>
        <div class="footer-value">Aujourd'hui</div>
    </div>
</aside>
