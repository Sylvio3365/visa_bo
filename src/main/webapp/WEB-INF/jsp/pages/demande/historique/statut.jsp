<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des statuts - ${idDemande}</title>
    <link rel="stylesheet" href="<c:url value='/webjars/bootstrap/5.3.3/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="<c:url value='/webjars/font-awesome/6.4.0/css/all.min.css' />">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">
    <style>
        :root {
            --primary-soft: #eef2ff;
            --accent-glow: rgba(12, 138, 123, 0.15);
        }

        body {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            min-height: 100vh;
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
        }

        .history-card {
            border: none;
            border-radius: 1.5rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
            background: #ffffff;
        }

        .timeline {
            position: relative;
            padding: 10px 0;
            list-style: none;
        }

        .timeline:before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 32px;
            width: 3px;
            background: linear-gradient(to bottom, var(--accent-color, #0c8a7b) 0%, #e2e8f0 100%);
            border-radius: 4px;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            transition: transform 0.2s ease;
        }

        @media (max-width: 576px) {
            .timeline:before {
                left: 20px;
            }

            .timeline-marker {
                left: 9px !important;
                width: 22px !important;
                height: 22px !important;
            }

            .timeline-content {
                margin-left: 45px !important;
                padding: 1rem !important;
            }

            .header-section {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 1rem;
            }

            .header-section > div {
                width: 100%;
            }

            .header-section .close-btn {
                width: 100%;
            }

            .container {
                padding-left: 1rem;
                padding-right: 1rem;
            }

            .status-badge {
                font-size: 0.8rem;
            }
        }

        .timeline-item:hover {
            transform: translateX(5px);
        }

        .timeline-marker {
            position: absolute;
            top: 5px;
            left: 21px;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #fff;
            border: 3px solid #e2e8f0;
            z-index: 1;
            transition: all 0.3s ease;
        }

        .timeline-item.active .timeline-marker {
            background: var(--accent-color, #0c8a7b);
            border-color: var(--accent-glow);
            box-shadow: 0 0 0 5px var(--accent-glow);
        }

        .timeline-content {
            margin-left: 70px;
            padding: 1.25rem;
            background: #fff;
            border-radius: 1rem;
            border: 1px solid rgba(226, 232, 240, 0.6);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
            transition: all 0.3s ease;
        }

        .timeline-item.active .timeline-content {
            border-left: 4px solid var(--accent-color, #0c8a7b);
            background: linear-gradient(to right, rgba(12, 138, 123, 0.02), #fff);
        }

        .status-badge {
            font-weight: 700;
            font-size: 0.9rem;
            padding: 0.4em 1em;
            border-radius: 12px;
            background: var(--primary-soft);
            color: #1e293b;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .timeline-item.active .status-badge {
            background: var(--accent-color, #0c8a7b);
            color: #fff;
        }

        .current-tag {
            font-size: 0.65rem;
            font-weight: 800;
            background: #1e293b;
            color: #f8fafc;
            padding: 3px 10px;
            border-radius: 6px;
            vertical-align: middle;
            margin-left: 8px;
        }

        .date-display {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 500;
        }

        .header-section {
            background: transparent;
            padding: 2rem 0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: #fff;
            padding: 1.25rem;
            border-radius: 1.25rem;
            border: 1px solid rgba(226, 232, 240, 0.6);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: block;
        }

        .info-value {
            font-weight: 600;
            color: #1e293b;
            font-size: 1rem;
        }
    </style>
</head>

<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="header-section d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="nt-title mb-1" style="font-size: 1.75rem;">Historique de la demande</h2>
                        <p class="text-muted mb-0">Reference : <span
                                class="badge bg-white text-dark border fw-bold">${idDemande}</span></p>
                    </div>
                    <!-- <a href="${pageContext.request.contextPath}/demandes/${idDemande}" class="btn btn-light border-0 shadow-sm rounded-pill px-4 close-btn">
                        <i class="fas fa-arrow-left me-2 text-primary"></i> Retour
                    </a> -->
                </div>

                <c:if test="${not empty demandeDetail}">
                    <div class="info-grid">
                        <div class="info-card">
                            <span class="info-label"><i class="fas fa-user-circle me-2"></i>Demandeur</span>
                            <div class="info-value">
                                ${demandeDetail.demande.demandeur.nom} ${demandeDetail.demande.demandeur.prenom}
                            </div>
                        </div>
                        <div class="info-card">
                            <span class="info-label"><i class="fas fa-id-card me-2"></i>Type de Visa</span>
                            <div class="info-value">${demandeDetail.demande.typeVisa.libelle}</div>
                        </div>
                        <div class="info-card">
                            <span class="info-label"><i class="fas fa-folder me-2"></i>Categorie</span>
                            <div class="info-value">${demandeDetail.demande.categorie.libelle}</div>
                        </div>
                        <div class="info-card">
                            <span class="info-label"><i class="far fa-calendar-plus me-2"></i>Date Creation</span>
                            <div class="info-value">${demandeDetail.demande.createdAt}</div>
                        </div>
                    </div>
                </c:if>

                <div class="card history-card">
                    <div class="card-header bg-transparent py-4 px-4 border-0">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-stream text-primary me-2"></i>Historique des
                            statuts</h5>
                    </div>
                    <div class="card-body px-4 pb-5">
                        <c:choose>
                            <c:when test="${not empty historique}">
                                <ul class="timeline">
                                    <c:forEach var="item" items="${historique}" varStatus="status">
                                        <li class="timeline-item ${status.first ? 'active' : ''}">
                                            <div class="timeline-marker"></div>
                                            <div class="timeline-content">
                                                <div
                                                    class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                                                    <div class="d-flex align-items-center flex-wrap gap-2">
                                                        <span class="status-badge">
                                                            ${item.statut.libelle}
                                                        </span>
                                                        <c:if test="${status.first}">
                                                            <span class="current-tag">ACTUEL</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="date-display ms-auto ms-sm-0">
                                                        <i class="far fa-calendar-alt me-1 opacity-50"></i>
                                                        ${item.date}
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <div class="mb-3">
                                        <i class="fas fa-folder-open fa-3x text-light"></i>
                                    </div>
                                    <p class="text-muted">Aucun historique disponible pour cette demande.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>
