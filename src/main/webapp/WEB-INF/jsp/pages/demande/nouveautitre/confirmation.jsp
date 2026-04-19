<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- CONFIRMATION -->
        <div class="container mt-4 nt-page">

            <div class="nt-page-head">
                <h1 class="nt-page-title"><i class="fas fa-pen-nib me-2"></i>Nouvelle demande de titre de visa</h1>
                <p class="nt-page-subtitle">Vérifiez le dossier avant validation finale.</p>
            </div>

            <!-- Stepper -->
            <jsp:include page="fragments/stepper.jsp" />

            <div class="row">
                <div class="">
                    <div class="card nt-confirm-card">
                        <div class="card-header nt-confirm-head">
                            <h2 class="mb-0"><i class="fas fa-check-double me-2"></i>Confirmation de Votre Demande</h2>
                        </div>
                        <div class="card-body p-4">

                            <div class="row">
                                <!-- Étape 1 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-user-circle me-2 text-success"></i><strong>Étape 1 : État
                                            Civil</strong>
                                    </h5>
                                    <div class="row">
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Nom & Prénom</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.nom && not empty
                                                        demandeForm.prenom ? demandeForm.nom.concat('
                                                        ').concat(demandeForm.prenom) : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Nom de jeune fille</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.nomJeuneFille ?
                                                        demandeForm.nomJeuneFille : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Date de naissance</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.dtn ? demandeForm.dtn :
                                                        'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Email</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.email ?
                                                        demandeForm.email : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Téléphone</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.telephone ?
                                                        demandeForm.telephone : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Nationalité</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.idNationalite ?
                                                        demandeForm.idNationalite : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Situation familiale</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.idSituationFamille ?
                                                        demandeForm.idSituationFamille : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Étape 2 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-passport me-2 text-success"></i><strong>Étape 2 :
                                            Passeport</strong>
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
                                                <small>Délivré le</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.dateDelivrancePassport ?
                                                        demandeForm.dateDelivrancePassport : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Expire le</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.dateExpirationPassport ?
                                                        demandeForm.dateExpirationPassport : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Étape 3 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-stamp me-2 text-success"></i><strong>Étape 3 : Visa
                                            Transformable</strong>
                                    </h5>
                                    <div class="row">
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Référence</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.refVisa ?
                                                        demandeForm.refVisa : 'N/A'}</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <div class="nt-confirm-value">
                                                <small>Durée</small>
                                                <p class="mb-0"><strong>${not empty demandeForm.dateDebut && not empty
                                                        demandeForm.dateFin ? demandeForm.dateDebut.toString().concat('
                                                        à ').concat(demandeForm.dateFin.toString()) : 'N/A'}</strong>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Étape 5 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-id-card me-2 text-success"></i><strong>Étape 5 : Type de
                                            Visa</strong>
                                    </h5>
                                    <div class="row">
                                        <div class="col-12">
                                            <c:choose>
                                                <c:when test="${not empty typeVisaLibelle}">
                                                    <span class="badge nt-badge-info"><i
                                                            class="fas fa-check me-1"></i>${typeVisaLibelle}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge nt-badge-danger"><i
                                                            class="fas fa-times me-1"></i>N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Étape 4 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-file-alt me-2 text-success"></i><strong>Étape 4 : Pièces
                                            Communes</strong>
                                    </h5>
                                    <c:choose>
                                        <c:when test="${not empty piecesCommunesAll}">
                                            <div class="row">
                                                <c:forEach var="piece" items="${piecesCommunesAll}">
                                                    <div class="col-12 mb-2">
                                                        <c:choose>
                                                            <c:when
                                                                test="${selectedPiecesCommunesIds.contains(piece.idPiece)}">
                                                                <span class="badge nt-badge-info"><i
                                                                        class="fas fa-check me-1"></i>${piece.libelle}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge nt-badge-danger"><i
                                                                        class="fas fa-times me-1"></i>${piece.libelle}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted"><i class="fas fa-info-circle me-2"></i>Aucune pièce
                                                sélectionnée</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Étape 6 -->
                                <div class="col-md-6 mb-4">
                                    <h5 class="nt-confirm-section-title">
                                        <i class="fas fa-file me-2 text-success"></i><strong>Étape 6 : Pièces
                                            Complémentaires</strong>
                                    </h5>
                                    <c:choose>
                                        <c:when test="${not empty piecesComplementairesAll}">
                                            <div class="row">
                                                <c:forEach var="piece" items="${piecesComplementairesAll}">
                                                    <div class="col-12 mb-2">
                                                        <c:choose>
                                                            <c:when
                                                                test="${selectedPiecesComplementairesIds.contains(piece.idPiece)}">
                                                                <span class="badge nt-badge-warn"><i
                                                                        class="fas fa-check me-1"></i>${piece.libelle}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge nt-badge-danger"><i
                                                                        class="fas fa-times me-1"></i>${piece.libelle}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted"><i class="fas fa-info-circle me-2"></i>Aucune pièce
                                                sélectionnée</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="d-flex gap-2 justify-content-center pt-3">
                                <button
                                    onclick="window.location.href='${pageContext.request.contextPath}/demande/etape1';"
                                    class="btn btn-outline-secondary btn-lg">
                                    <i class="fas fa-edit me-2"></i>Modifier
                                </button>
                                <button
                                    onclick="window.location.href='${pageContext.request.contextPath}/demande/terminer';"
                                    class="btn btn-success btn-lg">
                                    <i class="fas fa-check-circle me-2"></i>Terminer
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>