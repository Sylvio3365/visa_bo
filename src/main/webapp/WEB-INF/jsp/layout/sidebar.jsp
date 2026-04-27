<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="bo-sidebar">
    <div class="sidebar-title">Navigation</div>
    <nav class="bo-nav">
        <details class="nav-group" ${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'open' : ''}>
            <summary class="${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                <i class="fas fa-passport"></i> Types de visa
            </summary>
            <div class="nav-submenu">
                <a class="${activePage eq 'type-visa' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa'/>"><i class="fas fa-list"></i> Liste</a>
                <a class="${activePage eq 'type-visa-add' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa/ajout'/>"><i class="fas fa-plus"></i> Ajout</a>
            </div>
        </details>
        <details class="nav-group" ${activePage eq 'demande' || activePage eq 'demande-list' || activePage eq 'Nouvelle demande' ? 'open' : ''}>
            <summary class="${activePage eq 'demande' || activePage eq 'demande-list' || activePage eq 'Nouvelle demande' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                <i class="fas fa-file-alt"></i> Demandes
            </summary>
            <div class="nav-submenu">
                <a class="${activePage eq 'demande-list' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/demandes'/>"><i class="fas fa-list"></i> Liste demande</a>
                <c:forEach var="categorie" items="${categories}">
                    <a class="${activePage eq '${categorie.libelle}' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/demande/${categorie.libelle}'/>"><i class="fas fa-tag"></i> ${categorie.libelle}</a>
                </c:forEach>
            </div>
        </details>
    </nav>
</aside>
