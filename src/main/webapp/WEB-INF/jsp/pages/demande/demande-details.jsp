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
    <c:if test="${not empty demande and not empty demande.idDemande}">
        <c:url var="qrImageUrl" value="/demandes/${demande.idDemande}/qr" />
        <c:url var="qrDownloadUrl" value="/demandes/${demande.idDemande}/qr/download" />
    </c:if>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">
    <style>
        .detail-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.62rem;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 700;
            border: 1px solid transparent;
        }

        .detail-badge-type {
            color: var(--accent-strong, #0a6d61);
            background: rgba(12, 138, 123, 0.12);
            border-color: rgba(12, 138, 123, 0.35);
        }

        .detail-badge-status {
            color: #1e3a8a;
            background: rgba(59, 130, 246, 0.14);
            border-color: rgba(59, 130, 246, 0.32);
        }

        .piece-item {
            border: 1px solid rgba(15, 23, 42, 0.08);
            border-radius: 0.8rem;
            padding: 0.7rem 0.85rem;
            background: #fff;
            position: relative;
            transition: all 0.2s ease;
        }

        .piece-item:hover {
            border-color: var(--accent, #0c8a7b);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .scan-piece-btn {
            position: absolute;
            top: 0.7rem;
            right: 0.85rem;
            width: 2.2rem;
            height: 2.2rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(12, 138, 123, 0.08);
            color: var(--accent-strong, #0a6d61);
            border: 1px solid rgba(12, 138, 123, 0.2);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .scan-piece-btn:hover {
            background: var(--accent, #0c8a7b);
            color: #fff;
            transform: translateY(-2px);
        }

        .piece-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 0.45rem;
            margin-top: 0.4rem;
        }

        .piece-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            border-radius: 999px;
            padding: 0.2rem 0.55rem;
            font-size: 0.74rem;
            font-weight: 700;
            border: 1px solid transparent;
        }

        .piece-tag-obligatoire {
            color: #7c2d12;
            background: rgba(251, 146, 60, 0.16);
            border-color: rgba(251, 146, 60, 0.45);
        }

        .piece-tag-optionnelle {
            color: #475569;
            background: rgba(148, 163, 184, 0.15);
            border-color: rgba(148, 163, 184, 0.35);
        }

        .piece-tag-fourni {
            color: var(--accent-strong, #0a6d61);
            background: rgba(12, 138, 123, 0.14);
            border-color: rgba(12, 138, 123, 0.35);
        }

        .piece-tag-manquant {
            color: #b91c1c;
            background: rgba(239, 68, 68, 0.14);
            border-color: rgba(239, 68, 68, 0.34);
        }

        .qr-thumb {
            width: 85px;
            height: 85px;
            border-radius: 0.75rem;
            border: 1px solid rgba(12, 138, 123, 0.3);
            background: #fff;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .qr-thumb:hover {
            transform: scale(1.05);
        }

        .qr-overlay {
            position: fixed;
            inset: 0;
            background: rgba(2, 6, 23, 0.72);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            z-index: 2000;
        }

        .qr-overlay.show {
            display: flex;
        }

        .qr-overlay-content {
            position: relative;
            background: #fff;
            border-radius: 1rem;
            padding: 1rem;
            box-shadow: 0 20px 45px rgba(2, 6, 23, 0.35);
            max-width: 90vw;
            max-height: 90vh;
            text-align: center;
        }

        .qr-focus-image {
            width: min(500px, 80vw);
            max-height: 70vh;
            object-fit: contain;
            border-radius: 0.6rem;
            border: 1px solid rgba(12, 138, 123, 0.3);
        }

        .qr-close-btn {
            position: absolute;
            top: -0.6rem;
            right: -0.6rem;
            border-radius: 999px;
            width: 2rem;
            height: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ef4444;
            color: #fff;
            border: none;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .view-doc-btn {
            position: absolute;
            top: 0.7rem;
            right: 0.85rem;
            width: 2.2rem;
            height: 2.2rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(59, 130, 246, 0.08);
            color: #1d4ed8;
            border: 1px solid rgba(59, 130, 246, 0.2);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .view-doc-btn:hover {
            background: #1d4ed8;
            color: #fff;
            transform: translateY(-2px);
        }

        .pdf-container {
            width: 100%;
            height: 70vh;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
        }

        .btn-scan-valid-icon {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0 1rem;
            height: 2.2rem;
            border-radius: 0.5rem;
            border: 1px solid rgba(25, 129, 227, 0.35);
            color: #1981e3;
            background: rgba(25, 129, 227, 0.08);
            transition: all 0.2s ease;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            white-space: nowrap;
        }

        .btn-scan-valid-icon:hover {
            background: #1981e3;
            color: #fff;
            transform: translateY(-2px);
        }
    </style>

    <div class="container nt-page">
        <div class="nt-page-head d-flex flex-wrap justify-content-between align-items-start gap-3">
            <div>
                <h1 class="nt-page-title"><i class="fas fa-folder-open me-2"></i>Fiche demande</h1>
                <p class="nt-page-subtitle">Consultation des informations principales d'une demande.</p>
            </div>
            <div class="d-flex gap-2">
                <c:if test="${demandeDetail.idStatut eq 'ST000002'}">
                    <button type="button" class="btn d-inline-flex align-items-center gap-2 fw-bold px-3 border-0 shadow-sm"
                       style="background: #6366f1; color: #fff; border-radius: 0.5rem; height: 2.2rem; font-size: 0.85rem;"
                       onclick="openAllDocsModal()"
                       title="Apercu des documents">
                        <i class="fas fa-file-pdf"></i>
                        Apercu documents
                    </button>

                    <a href="${pageContext.request.contextPath}/demandes/${demande.idDemande}/accuse-reception" 
                       target="_blank"
                       class="btn d-inline-flex align-items-center gap-2 fw-bold px-3 border-0 shadow-sm"
                       style="background: #10b981; color: #fff; border-radius: 0.5rem; height: 2.2rem; font-size: 0.85rem;"
                       title="Telecharger Accuse de reception">
                        <i class="fas fa-download"></i>
                        Accuse reception
                    </a>
                </c:if>

                <c:if test="${demandeDetail.idStatut eq 'ST000001' or demandeDetail.idStatut eq 'ST000004'}">
                    <button type="button" class="btn d-inline-flex align-items-center gap-2 fw-bold px-3 border-0 shadow-sm"
                       style="background: #0ea5e9; color: #fff; border-radius: 0.5rem; height: 2.2rem; font-size: 0.85rem;"
                       onclick="openPhotoSignatureModal()"
                       title="Passer au signature et photo d'identite">
                        <i class="fas fa-camera"></i>
                        Signature et Photo
                    </button>
                </c:if>

                <c:if test="${demandeDetail.scanComplet && demandeDetail.idStatut eq 'ST000004'}">
                    <form action="${pageContext.request.contextPath}/demandes/valider-scan" method="POST" style="display:inline;">
                        <input type="hidden" name="idDemande" value="${demande.idDemande}">
                        <button type="submit" class="btn-scan-valid-icon border-0 shadow-sm" 
                             title="Valider scan (ST000002)">
                            <i class="fas fa-check-circle"></i>
                            Terminer scan
                        </button>
                    </form>
                </c:if>
                <c:if test="${isModifiable and demandeDetail.idStatut eq 'ST000001'}">
                    <!-- <a href="${pageContext.request.contextPath}/demandes/${demande.idDemande}/historique"
                        class="btn d-inline-flex align-items-center gap-2 fw-bold px-4 border-0 shadow-sm"
                        style="background: #1e293b; color: #fff; border-radius: 0.8rem;"
                        title="Voir l'historique des statuts">
                        <i class="fas fa-history"></i> Historique
                    </a> -->
                    <a href="${pageContext.request.contextPath}/demandes/${demande.idDemande}/modifier"
                        class="btn d-inline-flex align-items-center gap-2 fw-bold px-3 border-0 shadow-sm"
                        style="background: #f59e0b; color: #fff; border-radius: 0.5rem; height: 2.2rem; font-size: 0.85rem;">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                </c:if>
                <a class="btn btn-outline-secondary d-inline-flex align-items-center px-3 border-0 shadow-sm"
                    href="${finalDemandesBackUrl}" style="background: #f1f5f9; color: #475569; border-radius: 0.5rem; height: 2.2rem; font-size: 0.85rem;">
                    <i class="fas fa-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-12">
                <div class="card shadow-sm nt-form-card">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start mb-4">
                            <h3 class="card-title nt-title mb-0"><i class="fas fa-clipboard-list me-2"></i>Informations
                                generales</h3>
                            <c:if test="${not empty demande and not empty demande.idDemande}">
                                <div class="position-relative">
                                    <img src="${qrImageUrl}" alt="QR code" class="qr-thumb border rounded shadow-sm"
                                        id="qrPreviewImage" title="Cliquez pour agrandir">
                                    <a href="${qrDownloadUrl}"
                                        class="btn btn-sm btn-dark position-absolute bottom-0 end-0 rounded-circle d-flex align-items-center justify-content-center shadow"
                                        title="Telecharger"
                                        style="width: 28px; height: 28px; transform: translate(30%, 30%); z-index: 5;">
                                        <i class="fas fa-download" style="font-size: 0.75rem;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">ID demande</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when test="${not empty demande and not empty demande.idDemande}">
                                            ${demande.idDemande}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Statut</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when test="${not empty demandeStatus}">
                                            <span class="detail-badge detail-badge-status"><i class="fas fa-signal"
                                                    aria-hidden="true"></i>${demandeStatus}</span>
                                        </c:when>
                                        <c:when test="${not empty demandeDetail and not empty demandeDetail.statut}">
                                            <span class="detail-badge detail-badge-status"><i class="fas fa-signal"
                                                    aria-hidden="true"></i>${demandeDetail.statut}</span>
                                        </c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Categorie</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.categorie and not empty demande.categorie.libelle}">
                                            ${demande.categorie.libelle}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Type visa</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.typeVisa and not empty demande.typeVisa.libelle}">
                                            <span class="detail-badge detail-badge-type"><i class="fas fa-id-card"
                                                    aria-hidden="true"></i>${demande.typeVisa.libelle}</span>
                                        </c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Date creation</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when test="${not empty demande and not empty demande.createdAt}">
                                            ${demande.createdAt}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Derniere mise a jour</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when test="${not empty demande and not empty demande.updatedAt}">
                                            ${demande.updatedAt}</c:when>
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
                        <h3 class="card-title nt-title mb-4"><i class="fas fa-user-circle me-2"></i>Informations du
                            demandeur</h3>
                        <div class="row g-3">
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">ID demandeur</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.idDemandeur}">
                                            ${demande.demandeur.idDemandeur}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Demandeur</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when test="${not empty demande and not empty demande.demandeur}">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty demande.demandeur.nom or not empty demande.demandeur.prenom}">
                                                    ${demande.demandeur.nom} ${demande.demandeur.prenom}
                                                </c:when>
                                                <c:when test="${not empty demande.demandeur.idDemandeur}">
                                                    ${demande.demandeur.idDemandeur}</c:when>
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
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.dtn}">
                                            ${demande.demandeur.dtn}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Nationalite</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.nationalite and not empty demande.demandeur.nationalite.libelle}">
                                            ${demande.demandeur.nationalite.libelle}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Situation familiale</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.situationFamille and not empty demande.demandeur.situationFamille.libelle}">
                                            ${demande.demandeur.situationFamille.libelle}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">                                <label class="form-label mb-1">Genre</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.genre}">
                                            ${demande.demandeur.genre.libelle}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">                                <label class="form-label mb-1">Telephone</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.telephone}">
                                            ${demande.demandeur.telephone}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <label class="form-label mb-1">Email</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.email}">
                                            ${demande.demandeur.email}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label mb-1">Adresse locale</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.demandeur and not empty demande.demandeur.adresseMada}">
                                            ${demande.demandeur.adresseMada}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <!-- Biometrie affichage -->
                            <div class="col-12 mt-4">
                                <div class="p-3 rounded-3" style="background: rgba(12, 138, 123, 0.03); border: 1px solid rgba(12, 138, 123, 0.1);">
                                    <h5 class="nt-title mb-3" style="font-size: 1rem;"><i class="fas fa-fingerprint me-2"></i>Donnees biometriques</h5>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="card h-100 border-0 shadow-sm">
                                                <div class="card-body text-center p-3">
                                                    <label class="form-label d-block fw-bold text-muted small mb-2">PHOTO D'IDENTITE</label>
                                                    <c:choose>
                                                        <c:when test="${not empty demande.demandeur.photo}">
                                                            <img src="${demande.demandeur.photo}" alt="Photo" class="img-fluid rounded border" style="max-height: 200px; width: auto; object-fit: contain; border-color: #0c8a7b !important;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="py-4 text-muted">
                                                                <i class="fas fa-camera-retro fa-2x mb-2 d-block opacity-25"></i>
                                                                <span class="small">Non disponible</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card h-100 border-0 shadow-sm">
                                                <div class="card-body text-center p-3">
                                                    <label class="form-label d-block fw-bold text-muted small mb-2">SIGNATURE</label>
                                                    <c:choose>
                                                        <c:when test="${not empty demande.demandeur.signature}">
                                                            <img src="${demande.demandeur.signature}" alt="Signature" class="img-fluid rounded border" style="max-height: 200px; width: auto; object-fit: contain; background: #fff; border-color: #0c8a7b !important;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="py-4 text-muted">
                                                                <i class="fas fa-pen-nib fa-2x mb-2 d-block opacity-25"></i>
                                                                <span class="small">Non disponible</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="card shadow-sm nt-form-card">
                    <div class="card-body p-4">
                        <h3 class="card-title nt-title mb-4"><i class="fas fa-passport me-2"></i>Informations du passeport
                        </h3>
                        <div class="row g-3">
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Numero passeport</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.passport and not empty demande.passport.numero}">
                                            ${demande.passport.numero}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Date delivrance passeport</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.passport and not empty demande.passport.delivreLe}">
                                            ${demande.passport.delivreLe}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Date expiration passeport</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.passport and not empty demande.passport.expireLe}">
                                            ${demande.passport.expireLe}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">ID passeport</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.passport and not empty demande.passport.idPassport}">
                                            ${demande.passport.idPassport}</c:when>
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
                        <h3 class="card-title nt-title mb-4"><i class="fas fa-stamp me-2"></i>Visa transformable</h3>
                        <div class="row g-3">
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">ID visa transformable</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.visaTransformable and not empty demande.visaTransformable.idVisaTransformable}">
                                            ${demande.visaTransformable.idVisaTransformable}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Reference visa</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.visaTransformable and not empty demande.visaTransformable.refVisa}">
                                            ${demande.visaTransformable.refVisa}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Date debut visa</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.visaTransformable and not empty demande.visaTransformable.dateDebut}">
                                            ${demande.visaTransformable.dateDebut}</c:when>
                                        <c:otherwise>Non renseigne</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label mb-1">Date fin visa</label>
                                <div class="text-body text-break lh-sm">
                                    <c:choose>
                                        <c:when
                                            test="${not empty demande and not empty demande.visaTransformable and not empty demande.visaTransformable.dateFin}">
                                            ${demande.visaTransformable.dateFin}</c:when>
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
                        <h3 class="card-title nt-title mb-4"><i class="fas fa-file-alt me-2"></i>Pieces communes</h3>
                        <c:choose>
                            <c:when test="${not empty piecesCommunes}">
                                <div class="row g-3">
                                    <c:forEach var="piece" items="${piecesCommunes}">
                                        <div class="col-12 col-lg-6">
                                            <div class="piece-item">
                                                <div class="fw-semibold text-body pe-5">${piece.libelle}</div>
                                                <div class="text-muted small">${piece.idPiece}</div>
                                                <div class="piece-meta">
                                                    <span
                                                        class="piece-tag ${piece.obligatoire ? 'piece-tag-obligatoire' : 'piece-tag-optionnelle'}">
                                                        <i class="fas ${piece.obligatoire ? 'fa-asterisk' : 'fa-circle'}"
                                                            aria-hidden="true"></i>
                                                        ${piece.obligatoire ? 'Obligatoire' : 'Optionnelle'}
                                                    </span>
                                                    <span
                                                        class="piece-tag ${piece.fourni ? 'piece-tag-fourni' : 'piece-tag-manquant'}">
                                                        <i class="fas ${piece.fourni ? 'fa-check-circle' : 'fa-times-circle'}"
                                                            aria-hidden="true"></i>
                                                        ${piece.fourni ? 'Fournie' : 'Non fournie'}
                                                    </span>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${piece.uploade}">
                                                        <button type="button" class="view-doc-btn"
                                                            onclick="viewDocument('${piece.libelle}', '${piece.chemin}')"
                                                            title="Voir le document">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${piece.fourni}">
                                                        <button type="button" class="scan-piece-btn"
                                                            onclick="openScanModal('${piece.libelle}', '${piece.idPiece}')"
                                                            title="Scanner / Importer">
                                                            <i class="fas fa-print"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="position-absolute top-0 end-0 mt-3 me-3 small text-danger fw-bold"
                                                            style="font-size: 0.65rem;">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted">Aucune piece commune.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="card shadow-sm nt-form-card">
                    <div class="card-body p-4">
                        <h3 class="card-title nt-title mb-4"><i class="fas fa-file me-2"></i>Pieces complementaires</h3>
                        <c:choose>
                            <c:when test="${not empty piecesComplementaires}">
                                <div class="row g-3">
                                    <c:forEach var="piece" items="${piecesComplementaires}">
                                        <div class="col-12 col-lg-6">
                                            <div class="piece-item">
                                                <div class="fw-semibold text-body pe-5">${piece.libelle}</div>
                                                <div class="text-muted small">${piece.idPiece}</div>
                                                <div class="piece-meta">
                                                    <span
                                                        class="piece-tag ${piece.obligatoire ? 'piece-tag-obligatoire' : 'piece-tag-optionnelle'}">
                                                        <i class="fas ${piece.obligatoire ? 'fa-asterisk' : 'fa-circle'}"
                                                            aria-hidden="true"></i>
                                                        ${piece.obligatoire ? 'Obligatoire' : 'Optionnelle'}
                                                    </span>
                                                    <span
                                                        class="piece-tag ${piece.fourni ? 'piece-tag-fourni' : 'piece-tag-manquant'}">
                                                        <i class="fas ${piece.fourni ? 'fa-check-circle' : 'fa-times-circle'}"
                                                            aria-hidden="true"></i>
                                                        ${piece.fourni ? 'Fournie' : 'Non fournie'}
                                                    </span>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${piece.uploade}">
                                                        <button type="button" class="view-doc-btn"
                                                            onclick="viewDocument('${piece.libelle}', '${piece.chemin}')"
                                                            title="Voir le document">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${piece.fourni}">
                                                        <button type="button" class="scan-piece-btn"
                                                            onclick="openScanModal('${piece.libelle}', '${piece.idPiece}')"
                                                            title="Scanner / Importer">
                                                            <i class="fas fa-print"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="position-absolute top-0 end-0 mt-3 me-3 small text-danger fw-bold"
                                                            style="font-size: 0.65rem;">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted">Aucune piece complementaire.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div>
    <!-- MODAL PHOTO & SIGNATURE -->
    <div class="modal fade" id="photoSignatureModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1rem;">
                <div class="modal-header border-0 bg-light p-4">
                    <h5 class="modal-title nt-title"><i class="fas fa-camera me-2"></i>Photo et Signature</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-3">Photo d'identite</h6>
                            <div class="mb-3 border rounded bg-dark position-relative overflow-hidden" style="height: 300px;">
                                <video id="webcam" autoplay playsinline style="width: 100%; height: 100%; object-fit: cover;"></video>
                                <canvas id="photoCanvas" style="display: none; width: 100%; height: 100%; object-fit: cover;"></canvas>
                                <div id="no-webcam" class="position-absolute translate-middle top-50 start-50 text-white text-center" style="display: none;">
                                    <i class="fas fa-video-slash fa-3x mb-2"></i>
                                    <p>Webcam non detectee</p>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button id="captureBtn" onclick="capturePhoto()" class="btn btn-primary flex-grow-1" style="background: var(--accent, #0c8a7b); border: none;">
                                    <i class="fas fa-camera me-2"></i>Capturer
                                </button>
                                <button id="retakeBtn" onclick="retakePhoto()" class="btn btn-outline-secondary flex-grow-1" style="display: none;">
                                    <i class="fas fa-sync me-2"></i>Reprendre
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-3">Signature</h6>
                            <div class="mb-3 border rounded bg-white position-relative" style="height: 300px; cursor: crosshair;">
                                <canvas id="signaturePad" width="500" height="300" style="width: 100%; height: 100%;"></canvas>
                                <button onclick="clearSignature()" class="btn btn-sm btn-outline-danger position-absolute" style="top: 10px; right: 10px;">
                                    <i class="fas fa-eraser"></i> Effacer
                                </button>
                            </div>
                            <p class="text-muted small">Signez avec votre souris ou tablette.</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-4">
                    <form action="${pageContext.request.contextPath}/demandes/valider-photo-signature" method="POST" class="w-100">
                        <input type="hidden" name="idDemande" value="${demande.idDemande}">
                        <input type="hidden" name="photoData" id="photoData">
                        <input type="hidden" name="signatureData" id="signatureData">
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" style="background: #1981e3; border: none;">
                            <i class="fas fa-check-circle me-2"></i>Valider et Terminer
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL SCAN / IMPORT -->
    <div class="modal fade" id="scanModal" tabindex="-1" aria-labelledby="scanModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1rem; overflow: hidden;">
                <div class="modal-header border-0 bg-light p-4">
                    <h5 class="modal-title nt-title" id="scanModalLabel" style="color: var(--accent-strong, #0a6d61);">
                        <i class="fas fa-print me-2"></i>Importation de piece
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div class="display-6 mb-2" style="color: var(--accent, #0c8a7b);">
                            <i class="fas fa-file-upload"></i>
                        </div>
                        <h6 class="text-muted text-uppercase small fw-bold" style="letter-spacing: 1px;">Piece a scanner
                            :</h6>
                        <h4 id="targetPieceName" class="fw-bold" style="color: #1e293b;">-</h4>
                        <span id="targetPieceId" class="badge bg-light text-muted border mt-2">ID: -</span>
                    </div>

                    <form id="scanForm" action="${pageContext.request.contextPath}/demandes/upload-piece" method="POST"
                        enctype="multipart/form-data">
                        <input type="hidden" name="idDemande" value="${demande.idDemande}">
                        <input type="hidden" name="idPiece" id="uploadIdPiece">
                        <div class="mb-4">
                            <label for="pieceFile" class="form-label fw-semibold" style="color: #475569;">Choisir un
                                fichier (PDF, JPG, PNG)</label>
                            <input type="file" name="file" class="form-control border-light shadow-sm" id="pieceFile"
                                accept=".pdf,.jpg,.jpeg,.png" style="border-radius: 0.6rem; padding: 0.6rem;" required>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary py-3 fw-bold border-0 shadow-sm"
                                style="background: var(--accent, #0c8a7b); border-radius: 0.8rem;">
                                <i class="fas fa-sync-alt me-2"></i>Lancer le scan / Importer
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL VIEW DOCUMENT -->
    <div class="modal fade" id="viewModal" tabindex="-1" aria-labelledby="viewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1rem;">
                <div class="modal-header border-0 p-4">
                    <h5 class="modal-title fw-bold" id="viewModalLabel" style="color: var(--accent-strong, #0a6d61);">
                        <i class="fas fa-file-pdf me-2"></i>Document : <span id="viewDocName"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0">
                    <iframe id="docViewer" class="pdf-container" src="" frameborder="0"></iframe>
                </div>
                <div class="modal-footer border-0 p-3">
                    <button type="button" class="btn btn-secondary px-4 fw-bold" data-bs-dismiss="modal"
                        style="border-radius: 0.6rem;">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL ALL DOCUMENTS -->
    <div class="modal fade" id="allDocsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1rem;">
                <div class="modal-header border-0 bg-light p-4">
                    <h5 class="modal-title nt-title"><i class="fas fa-file-pdf me-2"></i>Apercu de tous les documents</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light">
                    <!-- Photo d'identite -->
                    <div class="mb-5 text-center">
                        <h4 class="fw-bold mb-3 border-bottom pb-2">Photo d'identite</h4>
                        <c:if test="${not empty demande.demandeur.photo}">
                            <img src="${demande.demandeur.photo}" alt="Photo didentite" style="max-height: 300px; border: 2px solid #ccc; padding: 5px;">
                        </c:if>
                        <c:if test="${empty demande.demandeur.photo}">
                            <p class="text-muted">Aucune photo disponible.</p>
                        </c:if>
                    </div>

                    <!-- Pieces communes -->
                    <div class="mb-4">
                        <h3 class="fw-bold text-uppercase" style="color: var(--accent-strong, #0a6d61);">Piece commune</h3>
                    </div>
                    <c:forEach var="piece" items="${piecesCommunes}">
                        <c:if test="${piece.uploade and piece.libelle ne '02 photos d’identité' and piece.libelle ne '02 photos d\\'identité'}">
                            <div class="mb-5">
                                <h5 class="fw-bold mb-2">
                                    Document : ${piece.libelle}
                                </h5>
                                <iframe src="${pageContext.request.contextPath}/demandes/document/${piece.chemin}" style="width: 100%; height: 800px; border: 1px solid #ddd; border-radius: 8px;"></iframe>
                            </div>
                        </c:if>
                    </c:forEach>

                    <!-- Pieces complementaires -->
                    <div class="mb-4 mt-5">
                        <h3 class="fw-bold text-uppercase" style="color: var(--accent-strong, #0a6d61);">Piece</h3>
                    </div>
                    <c:forEach var="piece" items="${piecesComplementaires}">
                        <c:if test="${piece.uploade}">
                            <div class="mb-5">
                                <h5 class="fw-bold mb-2">
                                    Document : ${piece.libelle}
                                </h5>
                                <iframe src="${pageContext.request.contextPath}/demandes/document/${piece.chemin}" style="width: 100%; height: 800px; border: 1px solid #ddd; border-radius: 8px;"></iframe>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- QR OVERLAY -->
    <div class="qr-overlay" id="qrOverlay">
        <div class="qr-overlay-content">
            <button type="button" class="qr-close-btn" id="qrCloseBtn" title="Fermer">
                <i class="fas fa-times"></i>
            </button>
            <h5 class="mb-3 fw-bold" style="color: var(--accent-strong, #0a6d61);">QR Code de la demande</h5>
            <img src="${qrImageUrl}" alt="QR code" class="qr-focus-image">
            <div class="mt-3">
                <a href="${qrDownloadUrl}" class="btn btn-outline-dark btn-sm">
                    <i class="fas fa-download me-2"></i>Telecharger le QR
                </a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const qrPreview = document.getElementById('qrPreviewImage');
            const qrOverlay = document.getElementById('qrOverlay');
            const qrCloseBtn = document.getElementById('qrCloseBtn');

            if (qrPreview && qrOverlay) {
                qrPreview.addEventListener('click', function () {
                    qrOverlay.classList.add('show');
                    document.body.style.overflow = 'hidden';
                });

                const closeOverlay = function () {
                    qrOverlay.classList.remove('show');
                    document.body.style.overflow = '';
                };

                qrCloseBtn.addEventListener('click', closeOverlay);

                qrOverlay.addEventListener('click', function (e) {
                    if (e.target === qrOverlay) {
                        closeOverlay();
                    }
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && qrOverlay.classList.contains('show')) {
                        closeOverlay();
                    }
                });
            }
        });

        function openAllDocsModal() {
            var modalEl = document.getElementById('allDocsModal');
            var myModal = new bootstrap.Modal(modalEl);
            myModal.show();
        }

        function openScanModal(libelle, id) {
            document.getElementById('targetPieceName').innerText = libelle;
            document.getElementById('targetPieceId').innerText = "ID: " + id;
            document.getElementById('uploadIdPiece').value = id;
            var modalEl = document.getElementById('scanModal');
            var myModal = new bootstrap.Modal(modalEl);
            myModal.show();
        }

        // --- PHOTO & SIGNATURE MODAL LOGIC ---
        function openPhotoSignatureModal() {
            const modalEl = document.getElementById('photoSignatureModal');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
            initWebcam();
            initSignaturePad();
            modalEl.addEventListener('hidden.bs.modal', stopWebcam);
        }

        let stream = null;
        function initWebcam() {
            const video = document.getElementById('webcam');
            const noWebcam = document.getElementById('no-webcam');
            if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({ video: { width: 640, height: 480 } })
                    .then(function(s) {
                        stream = s;
                        video.srcObject = stream;
                        video.style.display = 'block';
                        noWebcam.style.display = 'none';
                    })
                    .catch(function(err) {
                        video.style.display = 'none';
                        noWebcam.style.display = 'block';
                    });
            }
        }

        function capturePhoto() {
            const video = document.getElementById('webcam');
            const canvas = document.getElementById('photoCanvas');
            const captureBtn = document.getElementById('captureBtn');
            const retakeBtn = document.getElementById('retakeBtn');
            const photoDataInput = document.getElementById('photoData');

            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            canvas.getContext('2d').drawImage(video, 0, 0);
            
            photoDataInput.value = canvas.toDataURL('image/png');
            video.style.display = 'none';
            canvas.style.display = 'block';
            captureBtn.style.display = 'none';
            retakeBtn.style.display = 'inline-block';
        }

        function retakePhoto() {
            document.getElementById('webcam').style.display = 'block';
            document.getElementById('photoCanvas').style.display = 'none';
            document.getElementById('captureBtn').style.display = 'inline-block';
            document.getElementById('retakeBtn').style.display = 'none';
            document.getElementById('photoData').value = '';
        }

        let painting = false;
        function initSignaturePad() {
            const canvas = document.getElementById('signaturePad');
            const ctx = canvas.getContext('2d');
            const dataInput = document.getElementById('signatureData');
            
            // Clear if already has content
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            function getPos(e) {
                const rect = canvas.getBoundingClientRect();
                const clientX = e.touches ? e.touches[0].clientX : e.clientX;
                const clientY = e.touches ? e.touches[0].clientY : e.clientY;
                return {
                    x: (clientX - rect.left) * (canvas.width / rect.width),
                    y: (clientY - rect.top) * (canvas.height / rect.height)
                };
            }

            canvas.onmousedown = canvas.ontouchstart = (e) => {
                painting = true;
                const pos = getPos(e);
                ctx.beginPath();
                ctx.moveTo(pos.x, pos.y);
            };

            canvas.onmousemove = canvas.ontouchmove = (e) => {
                if (!painting) return;
                e.preventDefault();
                const pos = getPos(e);
                ctx.lineTo(pos.x, pos.y);
                ctx.lineWidth = 3;
                ctx.lineCap = 'round';
                ctx.strokeStyle = '#000';
                ctx.stroke();
            };

            canvas.onmouseup = canvas.ontouchend = () => {
                painting = false;
                dataInput.value = canvas.toDataURL('image/png');
            };
        }

        function clearSignature() {
            const canvas = document.getElementById('signaturePad');
            canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
            document.getElementById('signatureData').value = '';
        }

        function stopWebcam() {
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
                stream = null;
            }
        }

        function viewDocument(libelle, filename) {
            document.getElementById('viewDocName').innerText = libelle;
            const viewerUrl = "${pageContext.request.contextPath}/demandes/document/" + filename;
            document.getElementById('docViewer').src = viewerUrl;
            var viewModalObj = new bootstrap.Modal(document.getElementById('viewModal'));
            viewModalObj.show();
        }

        function closeScanModal() {
            var modalEl = document.getElementById('scanModal');
            var modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
        }
    </script>
</body>
</html>