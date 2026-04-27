<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

<div class="container mt-4 nt-page">
    <!-- Affichage des erreurs de validation -->
    <c:if test="${hasErrors}">
        <div class="nt-error-alert alert-dismissible fade show" role="alert">
            <div class="nt-error-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-triangle me-3"></i>
                    <h4 class="mb-0">Erreurs de validation</h4>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <div class="nt-error-body">
                <c:choose>
                    <c:when test="${not empty validationErrors}">
                        <ul class="mb-0 ps-4">
                            <c:forEach var="error" items="${validationErrors}">
                                <li class="mb-2">${error}</li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="mb-0"><strong>${errorMessage}</strong></p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="d-flex gap-2 justify-content-center pt-3">
            <button
                onclick="window.location.href='${pageContext.request.contextPath}/demande/confirmation';"
                class="btn btn-outline-secondary btn-lg">
                <i class="fas fa-arrow-left me-2"></i>Retour à la confirmation
            </button>
        </div>
    </c:if>

    <!-- Affichage du succès -->
    <c:if test="${!hasErrors}">
        <div class="nt-success-alert alert-dismissible fade show" role="alert">
            <div class="nt-success-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-check-circle me-3"></i>
                    <h4 class="mb-0">Demande enregistrée avec succès</h4>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <div class="nt-success-body">
                <p class="mb-0">Votre demande de titre de visa a été enregistrée avec succès dans le système.</p>
                <p class="mb-0 mt-2"><strong>Identifiant demande:</strong> ${demandeForm.idDemande}</p>
                <p class="mb-0"><strong>Identifiant demandeur:</strong> ${demandeForm.idDemandeur}</p>
            </div>
        </div>
        <h1>Tokony atao miredirect vers liste na fiche demande fa mbola ts vita</h1>
        <div class="d-flex gap-2 justify-content-center pt-4">
            <button
                onclick="window.location.href='${pageContext.request.contextPath}/demande/Nouvelle demande';"
                class="btn btn-primary btn-lg">
                <i class="fas fa-plus-circle me-2"></i>Nouvelle demande
            </button>
            <button
                onclick="window.location.href='${pageContext.request.contextPath}/';"
                class="btn btn-outline-secondary btn-lg">
                <i class="fas fa-home me-2"></i>Accueil
            </button>
        </div>
    </c:if>
</div>
