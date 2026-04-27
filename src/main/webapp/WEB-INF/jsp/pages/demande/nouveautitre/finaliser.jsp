<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

<!-- FINALISATION DEMANDE DIRECTE -->
<div class="container mt-4 nt-page">

    <div class="nt-page-head">
        <h1 class="nt-page-title"><i class="fas fa-check me-2"></i>Finalisation Demande</h1>
        <p class="nt-page-subtitle">Confirmez la création de votre nouvelle demande.</p>
    </div>

    <!-- Stepper -->
    <jsp:include page="fragments/stepper.jsp" />

    <div class="row">
        <div class="">
            <div class="card nt-confirm-card">
                <div class="card-header nt-confirm-head">
                    <h2 class="mb-0"><i class="fas fa-check-circle me-2"></i>Confirmation Finale</h2>
                </div>
                <div class="card-body p-4">

                    <!-- Messages de validation -->
                    <c:if test="${not empty validationErrors}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <h4 class="alert-heading">❌ Erreurs de validation</h4>
                            <c:forEach var="error" items="${validationErrors}">
                                <p class="mb-1"><i class="fas fa-exclamation-circle"></i> ${error}</p>
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- Type de demande -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Type de demande :</strong> Nouvelle demande de titre de visa
                            </div>
                        </div>
                    </div>

                    <!-- Résumé des données -->
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <h5 class="nt-confirm-section-title">
                                <i class="fas fa-user-circle me-2 text-success"></i><strong>Demandeur</strong>
                            </h5>
                            <div class="row">
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Nom & Prénom</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.nom && not empty demandeForm.prenom ? 
                                            demandeForm.nom.concat(' ').concat(demandeForm.prenom) : 'N/A'}</strong></p>
                                    </div>
                                </div>
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Date de naissance</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.dtn ? demandeForm.dtn : 'N/A'}</strong></p>
                                    </div>
                                </div>
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Email</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.email ? demandeForm.email : 'N/A'}</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <h5 class="nt-confirm-section-title">
                                <i class="fas fa-passport me-2 text-success"></i><strong>Passport</strong>
                            </h5>
                            <div class="row">
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Numéro</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.numPassport ? 
                                            demandeForm.numPassport : 'N/A'}</strong></p>
                                    </div>
                                </div>
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Valide jusqu'au</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.dateExpirationPassport ? 
                                            demandeForm.dateExpirationPassport : 'N/A'}</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Visa Transformable & Type Visa -->
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <h5 class="nt-confirm-section-title">
                                <i class="fas fa-stamp me-2 text-success"></i><strong>Visa Transformable</strong>
                            </h5>
                            <div class="row">
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Référence</small>
                                        <p class="mb-0"><strong>${not empty demandeForm.refVisa ? 
                                            demandeForm.refVisa : 'N/A'}</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <h5 class="nt-confirm-section-title">
                                <i class="fas fa-id-card me-2 text-success"></i><strong>Type de Visa Demandé</strong>
                            </h5>
                            <div class="row">
                                <div class="col-12 mb-2">
                                    <div class="nt-confirm-value">
                                        <small>Type</small>
                                        <p class="mb-0"><strong>${typeVisaLibelle}</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pièces sélectionnées -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <h5 class="nt-confirm-section-title">
                                <i class="fas fa-file me-2 text-success"></i><strong>Documents</strong>
                            </h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <small class="text-muted">Pièces Communes</small>
                                    <ul class="list-unstyled">
                                        <c:forEach var="piece" items="${piecesCommunesAll}">
                                            <c:if test="${selectedPiecesCommunesIds.contains(piece.idPiece)}">
                                                <li><i class="fas fa-check text-success"></i> ${piece.libelle}</li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <small class="text-muted">Pièces Complémentaires</small>
                                    <ul class="list-unstyled">
                                        <c:forEach var="piece" items="${piecesComplementairesAll}">
                                            <c:if test="${selectedPiecesComplementairesIds.contains(piece.idPiece)}">
                                                <li><i class="fas fa-check text-success"></i> ${piece.libelle}</li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Boutons d'action -->
                <div class="card-footer bg-light p-3">
                    <div class="d-flex gap-2 justify-content-between">
                        <a href="<c:url value='/demande/etape1'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Modifier
                        </a>
                        <form method="post" action="<c:url value='/demande/finaliser'/>" style="display:inline;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check"></i> Créer la Demande
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

</div>
