<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

<!-- ETAPE 7 : VISA -->
<div class="container nt-page">
    <div class="nt-page-head">
        <h1 class="nt-page-title"><i class="fas fa-pen-nib me-2"></i>Créer un Visa</h1>
        <p class="nt-page-subtitle">Entrez les informations du visa pour cette nouvelle demande.</p>
    </div>

    <!-- Stepper -->
    <jsp:include page="fragments/stepper.jsp" />

    <!-- AFFICHAGE DES ERREURS DE VALIDATION -->
    <c:if test="${not empty validationErrors}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <h4 class="alert-heading">❌ Erreurs de validation</h4>
            <c:forEach var="error" items="${validationErrors}">
                <p class="mb-1"><i class="fas fa-exclamation-circle"></i> ${error}</p>
            </c:forEach>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4">
                    <form method="post" action="<c:url value='/demande/etape7'/>">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="visaRefVisa" class="form-label">Référence Visa <span class="text-danger">*</span></label>
                                <input type="text" id="visaRefVisa" name="visaRefVisa" class="form-control"
                                       value="${demandeForm.visaRefVisa}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="visaDateDebut" class="form-label">Date de Début <span class="text-danger">*</span></label>
                                <input type="date" id="visaDateDebut" name="visaDateDebut" class="form-control"
                                       value="${demandeForm.visaDateDebut}" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="visaDateFin" class="form-label">Date de Fin <span class="text-danger">*</span></label>
                                <input type="date" id="visaDateFin" name="visaDateFin" class="form-control"
                                       value="${demandeForm.visaDateFin}" required>
                            </div>
                        </div>

                        <div class="d-flex gap-2 justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-arrow-right me-2"></i>Continuer
                            </button>
                            <a href="<c:url value='/demande/etape6'/>" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Retour
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
