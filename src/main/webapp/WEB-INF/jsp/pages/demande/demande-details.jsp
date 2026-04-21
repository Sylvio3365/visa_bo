<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="defaultDemandesUrl" value="/demandes" />
<c:choose>
    <c:when test="${not empty demandesBackUrl}">
        <c:set var="finalDemandesBackUrl" value="${pageContext.request.contextPath}${demandesBackUrl}" />
    </c:when>
    <c:otherwise>
        <c:set var="finalDemandesBackUrl" value="${defaultDemandesUrl}" />
    </c:otherwise>
</c:choose>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

<div class="container nt-page">
    <div class="nt-page-head d-flex flex-wrap justify-content-between align-items-start gap-3">
        <div>
            <h1 class="nt-page-title"><i class="fas fa-folder-open me-2"></i>Fiche demande</h1>
            <p class="nt-page-subtitle">Consultation des informations principales d'une demande.</p>
        </div>
        <a class="btn btn-outline-secondary" href="${finalDemandesBackUrl}">
            <i class="fas fa-arrow-left me-2"></i>Retour a la liste
        </a>
    </div>

    <div class="row g-4">
        <div class="col-12">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4">
                    <h3 class="card-title nt-title mb-4"><i class="fas fa-clipboard-list me-2"></i>Informations generales</h3>
                    <div class="row g-3">
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">ID demande</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.idDemande}">${demande.idDemande}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Statut</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demandeStatus}">${demandeStatus}</c:when>
                                    <c:when test="${not empty demandeDetail and not empty demandeDetail.statut}">${demandeDetail.statut}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Categorie</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.categorie and not empty demande.categorie.libelle}">${demande.categorie.libelle}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Type visa</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.typeVisa and not empty demande.typeVisa.libelle}">${demande.typeVisa.libelle}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Date creation</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.createdAt}">${demande.createdAt}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Derniere mise a jour</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.updatedAt}">${demande.updatedAt}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4">
                    <h3 class="card-title nt-title mb-4"><i class="fas fa-user-circle me-2"></i>Informations du demandeur</h3>
                    <div class="row g-3">
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Demandeur</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur}">
                                        <c:choose>
                                            <c:when test="${not empty demande.demandeur.nom or not empty demande.demandeur.prenom}">
                                                ${demande.demandeur.nom} ${demande.demandeur.prenom}
                                            </c:when>
                                            <c:when test="${not empty demande.demandeur.idDemandeur}">${demande.demandeur.idDemandeur}</c:when>
                                            <c:otherwise>Non renseigne</c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Date de naissance</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.dtn}">${demande.demandeur.dtn}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Nationalite</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.nationalite and not empty demande.demandeur.nationalite.libelle}">${demande.demandeur.nationalite.libelle}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Situation familiale</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.situationFamille and not empty demande.demandeur.situationFamille.libelle}">${demande.demandeur.situationFamille.libelle}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Telephone</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.telephone}">${demande.demandeur.telephone}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label class="form-label mb-1">Email</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.email}">${demande.demandeur.email}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label mb-1">Adresse locale</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.adresseMada}">${demande.demandeur.adresseMada}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4">
                    <h3 class="card-title nt-title mb-4"><i class="fas fa-passport me-2"></i>Informations du passeport</h3>
                    <div class="row g-3">
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label mb-1">Numero passeport</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.passport and not empty demande.passport.numero}">${demande.passport.numero}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label mb-1">Date delivrance passeport</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.passport and not empty demande.passport.delivreLe}">${demande.passport.delivreLe}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label mb-1">Date expiration passeport</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.passport and not empty demande.passport.expireLe}">${demande.passport.expireLe}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label mb-1">ID passeport</label>
                            <div class="text-body text-break lh-sm">
                                <c:choose>
                                    <c:when test="${not empty demande and not empty demande.passport and not empty demande.passport.idPassport}">${demande.passport.idPassport}</c:when>
                                    <c:otherwise>Non renseigne</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="alert alert-info mt-4 mb-0" role="status">
        <i class="fas fa-info-circle me-2"></i>Les champs absents sont affiches comme "Non renseigne".
    </div>
</div>