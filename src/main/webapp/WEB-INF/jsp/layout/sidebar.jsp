<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="bo-sidebar">
    <div class="sidebar-title">Navigation</div>
    <nav class="bo-nav">
        <a class="${activePage eq 'dashboard' ? 'nav-link active' : 'nav-link'}" href="<c:url value='/'/>"><i class="fas fa-home"></i> Dashboard</a>
        <details class="nav-group" ${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'open' : ''}>
            <summary class="${activePage eq 'type-visa' || activePage eq 'type-visa-add' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                <i class="fas fa-passport"></i> Types de visa
            </summary>
            <div class="nav-submenu">
                <a class="${activePage eq 'type-visa' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa'/>"><i class="fas fa-list"></i> Liste</a>
                <a class="${activePage eq 'type-visa-add' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/type-visa/ajout'/>"><i class="fas fa-plus"></i> Ajout</a>
            </div>
        </details>
        <details class="nav-group" ${activePage eq 'demande' || activePage eq 'demande-list' || activePage eq 'nouveau-titre' ? 'open' : ''}>
            <summary class="${activePage eq 'demande' || activePage eq 'demande-list' || activePage eq 'nouveau-titre' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                <i class="fas fa-file-alt"></i> Demandes
            </summary>
            <div class="nav-submenu">
                <a class="${activePage eq 'demande-list' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/demandes'/>"><i class="fas fa-list"></i> Liste demande</a>
                <a class="${activePage eq 'nouveau-titre' ? 'nav-sublink active' : 'nav-sublink'}" href="<c:url value='/demande/nouveau-titre'/>"><i class="fas fa-pen-to-square"></i> Nouveau titre</a>
            </div>
        </details>
        <details class="nav-group" ${activePage eq 'categorie' ? 'open' : ''}>
            <summary class="${activePage eq 'categorie' ? 'nav-link nav-group-toggle active' : 'nav-link nav-group-toggle'}">
                <i class="fas fa-folder-open"></i> Catégories de demande
            </summary>
            <div class="nav-submenu">
                <c:forEach var="categorie" items="${categories}">
                    <a class="nav-sublink" href="<c:url value='/demandes?categorie=${categorie.idCategorie}'/>"><i class="fas fa-tag"></i> ${categorie.libelle}</a>
                </c:forEach>
            </div>
        </details>
        <a class="nav-link" href="#"><i class="fas fa-user"></i> Demandeurs</a>
        <a class="nav-link" href="#"><i class="fas fa-check-square"></i> Statuts</a>
    </nav>
</aside>
