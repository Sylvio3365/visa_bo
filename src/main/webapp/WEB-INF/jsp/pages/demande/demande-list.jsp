<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="demandesUrl" value="/demandes" />
<c:set var="startDateValue" value="${not empty startDateFilter ? startDateFilter : param.startDate}" />
<c:set var="endDateValue" value="${not empty endDateFilter ? endDateFilter : param.endDate}" />
<c:set var="typeVisaValue" value="${not empty typeVisaFilter ? typeVisaFilter : param.typeVisa}" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">
<style>
    .filter-pill-btn {
        display: inline-flex;
        align-items: center;
        gap: 0.45rem;
        border-radius: 999px;
        padding: 0.35rem 0.85rem;
        font-weight: 600;
        line-height: 1;
    }

    .filter-pill-btn .filter-chevron-icon {
        font-size: 0.8rem;
        transition: transform 0.2s ease;
    }

    .demande-filters {
        border-radius: 1rem;
    }

    .demande-filters .filter-section {
        border: 1px solid rgba(15, 23, 42, 0.08);
        border-radius: 0.85rem;
        padding: 0.9rem;
        background: linear-gradient(180deg, rgba(248, 250, 252, 0.95) 0%, rgba(255, 255, 255, 0.98) 100%);
    }

    .demande-filters .filter-section-title {
        font-size: 0.82rem;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        color: #475569;
        font-weight: 700;
        margin-bottom: 0.75rem;
    }

    .demande-filters .form-label {
        font-size: 0.82rem;
        font-weight: 600;
        color: #334155;
        margin-bottom: 0.35rem;
    }

    .demande-filters .form-control,
    .demande-filters .form-select {
        border-color: rgba(12, 138, 123, 0.24);
        border-radius: 0.65rem;
        min-height: 2.15rem;
    }

    .demande-filters .form-control:focus,
    .demande-filters .form-select:focus {
        border-color: var(--accent-strong, #0a6d61);
        box-shadow: 0 0 0 0.16rem var(--ring, rgba(12, 138, 123, 0.2));
    }

    .demande-filters .filter-actions {
        border-top: 1px dashed rgba(15, 23, 42, 0.14);
        padding-top: 0.9rem;
    }

    .type-visa-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
        padding: 0.32rem 0.62rem;
        border-radius: 999px;
        font-size: 0.78rem;
        font-weight: 700;
        color: var(--accent-strong, #0a6d61);
        background: rgba(12, 138, 123, 0.12);
        border: 1px solid rgba(12, 138, 123, 0.35);
    }

    .type-visa-badge.badge-travailleur {
        color: #0a6d61;
        background: rgba(12, 138, 123, 0.14);
        border-color: rgba(12, 138, 123, 0.4);
    }

    .type-visa-badge.badge-investisseur {
        color: #1d4ed8;
        background: rgba(37, 99, 235, 0.13);
        border-color: rgba(37, 99, 235, 0.35);
    }

    .type-visa-badge.badge-default {
        color: #475569;
        background: rgba(100, 116, 139, 0.12);
        border-color: rgba(100, 116, 139, 0.3);
    }

    .btn-detail-icon {
        width: 2rem;
        height: 2rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        border: 1px solid rgba(12, 138, 123, 0.35);
        color: var(--accent-strong, #0a6d61);
        background: rgba(12, 138, 123, 0.08);
        transition: all 0.18s ease;
        text-decoration: none;
    }

    .btn-edit-icon {
        width: 2rem;
        height: 2rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        border: 1px solid rgba(245, 158, 11, 0.35);
        color: #d97706;
        background: rgba(245, 158, 11, 0.08);
        transition: all 0.18s ease;
        text-decoration: none;
    }

    .btn-scan-valid-icon {
        width: 2rem;
        height: 2rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        border: 1px solid rgba(25, 129, 227, 0.35);
        color: #1981e3;
        background: rgba(25, 129, 227, 0.08);
        transition: all 0.18s ease;
        text-decoration: none;
        cursor: default; 
    }

    .btn-scan-valid-icon:hover {
        color: #fff;
        background: #1981e3;
        border-color: #1981e3;
        transform: translateY(-1px);
    }

    .btn-detail-icon:hover,
    .btn-detail-icon:focus {
        color: #fff;
        background: var(--accent, #0c8a7b);
        border-color: var(--accent, #0c8a7b);
        box-shadow: 0 0 0 0.16rem var(--ring, rgba(12, 138, 123, 0.2));
        text-decoration: none;
    }

    .btn-edit-icon:hover,
    .btn-edit-icon:focus {
        color: #fff;
        background: #f59e0b;
        border-color: #f59e0b;
        box-shadow: 0 0 0 0.16rem rgba(245, 158, 11, 0.2);
        text-decoration: none;
    }
</style>

<div class="nt-page">
<section class="hero nt-page-head mb-4">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <div class="pill">Demandes</div>
            <h1 class="mt-3">Liste des demandes</h1>
            <p class="lead mb-0">Consultez les dossiers, leur statut actuel et accedez rapidement au detail.</p>
        </div>
        <div class="d-flex gap-2">
            <button
                class="btn btn-outline-primary btn-sm filter-chevron-btn filter-pill-btn"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#demandeFiltersCollapse"
                aria-expanded="false"
                aria-controls="demandeFiltersCollapse"
                aria-label="Basculer le panneau des filtres"
                title="Basculer les filtres"
            >
                <i class="fas fa-sliders-h" aria-hidden="true"></i>
                Filtres
                <i class="fas fa-chevron-down filter-chevron-icon" aria-hidden="true"></i>
                <span class="visually-hidden">Basculer les filtres</span>
            </button>
            <a class="btn btn-outline-success btn-sm" href="${demandesUrl}">Recharger</a>
        </div>
    </div>

    <div class="collapse mt-3" id="demandeFiltersCollapse">
        <div class="card shadow-sm nt-form-card demande-filters">
            <div class="card-body p-3 p-md-4">
            <h2 class="card-title nt-title h5 mb-3"><i class="fas fa-sliders-h me-2"></i>Filtres de recherche</h2>
            <form class="row g-3" method="get" action="${demandesUrl}">
                <input type="hidden" name="page" value="1" />
                <div class="col-12 col-lg-8">
                    <div class="filter-section h-100">
                        <div class="filter-section-title">Recherche</div>
                        <div class="row g-3 align-items-end">
                            <div class="col-12 col-md-6 col-xl-4">
                                <label class="form-label" for="statusFilter">Statut</label>
                                <select class="form-select form-select-sm" id="statusFilter" name="status">
                                    <option value="">Tous les statuts</option>
                                    <c:forEach var="statusOption" items="${statusOptions}">
                                        <option value="${statusOption}" ${statusOption eq statusFilter ? 'selected' : ''}>${statusOption}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 col-md-6 col-xl-4">
                                <label class="form-label" for="typeVisaFilter">Type visa</label>
                                <select class="form-select form-select-sm" id="typeVisaFilter" name="typeVisa">
                                    <option value="">Tous les types</option>
                                    <c:forEach var="typeVisaOption" items="${typeVisaOptions}">
                                        <option value="${typeVisaOption.idTypeVisa}" ${typeVisaOption.idTypeVisa eq typeVisaValue ? 'selected' : ''}>
                                            <c:choose>
                                                <c:when test="${not empty typeVisaOption.libelle}">
                                                    ${typeVisaOption.libelle}
                                                </c:when>
                                                <c:otherwise>
                                                    Type #${typeVisaOption.idTypeVisa}
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 col-xl-4">
                                <label class="form-label" for="searchFilter">Recherche (ID ou demandeur)</label>
                                <input class="form-control form-control-sm" id="searchFilter" type="text" name="search" value="${searchFilter}" maxlength="100"
                                    placeholder="Ex: DEM-2026 ou Nom" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="filter-section h-100">
                        <div class="filter-section-title">Periode et affichage</div>
                        <div class="row g-3 align-items-end">
                            <div class="col-6 col-md-4 col-lg-12">
                                <label class="form-label" for="sizeFilter">Lignes</label>
                                <select class="form-select form-select-sm" id="sizeFilter" name="size" onchange="this.form.submit()">
                                    <c:forEach var="sizeOption" items="${pageSizeOptions}">
                                        <option value="${sizeOption}" ${sizeOption eq pageSize ? 'selected' : ''}>${sizeOption}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-6 col-md-4 col-lg-6">
                                <label class="form-label" for="startDateFilter">Date debut</label>
                                <input class="form-control form-control-sm" id="startDateFilter" type="date" name="startDate" value="${startDateValue}" />
                            </div>
                            <div class="col-6 col-md-4 col-lg-6">
                                <label class="form-label" for="endDateFilter">Date fin</label>
                                <input class="form-control form-control-sm" id="endDateFilter" type="date" name="endDate" value="${endDateValue}" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 d-flex flex-wrap gap-2 filter-actions">
                    <button class="btn btn-primary btn-sm" type="submit">Filtrer</button>
                    <c:url var="resetFiltersUrl" value="/demandes">
                        <c:param name="page" value="1" />
                        <c:param name="size" value="${pageSize}" />
                        <c:if test="${not empty statusFilter}">
                            <c:param name="status" value="${statusFilter}" />
                        </c:if>
                        <c:if test="${not empty searchFilter}">
                            <c:param name="search" value="${searchFilter}" />
                        </c:if>
                        <c:if test="${not empty startDateValue}">
                            <c:param name="startDate" value="${startDateValue}" />
                        </c:if>
                        <c:if test="${not empty endDateValue}">
                            <c:param name="endDate" value="${endDateValue}" />
                        </c:if>
                        <c:if test="${not empty typeVisaValue}">
                            <c:param name="typeVisa" value="${typeVisaValue}" />
                        </c:if>
                    </c:url>
                    <a class="btn btn-outline-secondary btn-sm" href="${resetFiltersUrl}">Reinitialiser</a>
                </div>
            </form>
            </div>
        </div>
    </div>
</section>

<div class="card-surface">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
        <h2 class="h5 mb-0">Tableau</h2>
        <c:if test="${not empty demandesPage}">
            <span class="status mt-0">${demandesPage.totalElements} demande(s) au total.</span>
        </c:if>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty warningMessage}">
        <div class="alert alert-warning" role="alert">
            ${warningMessage}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty demandes}">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Demandeur</th>
                            <th scope="col">Type visa</th>
                            <th scope="col">Cree le</th>
                            <th scope="col">Statut</th>
                            <th scope="col" class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${demandes}">
                            <c:url var="detailUrl" value="/demandes/${item.demande.idDemande}">
                                <c:param name="page" value="${currentPage}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:if test="${not empty statusFilter}">
                                    <c:param name="status" value="${statusFilter}" />
                                </c:if>
                                <c:if test="${not empty searchFilter}">
                                    <c:param name="search" value="${searchFilter}" />
                                </c:if>
                                <c:if test="${not empty startDateValue}">
                                    <c:param name="startDate" value="${startDateValue}" />
                                </c:if>
                                <c:if test="${not empty endDateValue}">
                                    <c:param name="endDate" value="${endDateValue}" />
                                </c:if>
                                <c:if test="${not empty typeVisaValue}">
                                    <c:param name="typeVisa" value="${typeVisaValue}" />
                                </c:if>
                            </c:url>
                            <tr>
                                <td class="fw-semibold">${item.demande.idDemande}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.demande.demandeur}">
                                            ${item.demande.demandeur.nom} ${item.demande.demandeur.prenom}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.demande.typeVisa}">
                                            <c:set var="visaBadgeClass" value="badge-default" />
                                            <c:choose>
                                                <c:when test="${item.demande.typeVisa.idTypeVisa eq 'TV000001' || item.demande.typeVisa.libelle eq 'Travailleur'}">
                                                    <c:set var="visaBadgeClass" value="badge-travailleur" />
                                                </c:when>
                                                <c:when test="${item.demande.typeVisa.idTypeVisa eq 'TV000002' || item.demande.typeVisa.libelle eq 'Investisseur'}">
                                                    <c:set var="visaBadgeClass" value="badge-investisseur" />
                                                </c:when>
                                            </c:choose>
                                            <span class="type-visa-badge ${visaBadgeClass}">
                                                <i class="fas fa-id-card" aria-hidden="true"></i>
                                                ${item.demande.typeVisa.libelle}
                                            </span>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.demande.createdAt}</td>
                                <td>
                                    <span class="badge text-bg-light border">${item.statut}</span>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-2">
                                        <c:if test="${item.scanComplet && item.idStatut ne 'ST000002'}">
                                            <form action="${pageContext.request.contextPath}/demandes/valider-scan" method="POST" style="display:inline;">
                                                <input type="hidden" name="idDemande" value="${item.demande.idDemande}">
                                                <button type="submit" class="btn-scan-valid-icon" title="Valider scan (ST000002)" style="border:none; padding:0;">
                                                    <i class="fas fa-check-circle" aria-hidden="true"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:url var="editUrl" value="/demandes/${item.demande.idDemande}/modifier" />
                                        <a class="btn-edit-icon" href="${editUrl}" aria-label="Modifier" title="Modifier">
                                            <i class="fas fa-edit" aria-hidden="true"></i>
                                        </a>
                                        <a class="btn-detail-icon" href="${detailUrl}" aria-label="Voir detail" title="Voir detail">
                                            <i class="fas fa-eye" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${not empty demandesPage and demandesPage.totalPages > 1}">
                <nav class="mt-3" aria-label="Pagination des demandes">
                    <ul class="pagination pagination-sm mb-0 justify-content-end flex-wrap gap-2 demande-pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <c:url var="prevPageUrl" value="/demandes">
                                    <c:param name="page" value="${currentPage - 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:if test="${not empty statusFilter}">
                                        <c:param name="status" value="${statusFilter}" />
                                    </c:if>
                                    <c:if test="${not empty searchFilter}">
                                        <c:param name="search" value="${searchFilter}" />
                                    </c:if>
                                    <c:if test="${not empty startDateValue}">
                                        <c:param name="startDate" value="${startDateValue}" />
                                    </c:if>
                                    <c:if test="${not empty endDateValue}">
                                        <c:param name="endDate" value="${endDateValue}" />
                                    </c:if>
                                    <c:if test="${not empty typeVisaValue}">
                                        <c:param name="typeVisa" value="${typeVisaValue}" />
                                    </c:if>
                                </c:url>
                                <li class="page-item page-item-nav">
                                    <a class="page-link" href="${prevPageUrl}" aria-label="Page precedente" title="Page precedente">
                                        <span aria-hidden="true">&lt;</span>
                                        <span class="visually-hidden">Precedent</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item page-item-nav disabled">
                                    <span class="page-link" aria-hidden="true">&lt;</span>
                                    <span class="visually-hidden">Precedent</span>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach var="pageNumber" begin="1" end="${demandesPage.totalPages}">
                            <c:url var="pageUrl" value="/demandes">
                                <c:param name="page" value="${pageNumber}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:if test="${not empty statusFilter}">
                                    <c:param name="status" value="${statusFilter}" />
                                </c:if>
                                <c:if test="${not empty searchFilter}">
                                    <c:param name="search" value="${searchFilter}" />
                                </c:if>
                                <c:if test="${not empty startDateValue}">
                                    <c:param name="startDate" value="${startDateValue}" />
                                </c:if>
                                <c:if test="${not empty endDateValue}">
                                    <c:param name="endDate" value="${endDateValue}" />
                                </c:if>
                                <c:if test="${not empty typeVisaValue}">
                                    <c:param name="typeVisa" value="${typeVisaValue}" />
                                </c:if>
                            </c:url>
                            <li class="page-item ${pageNumber eq currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageUrl}" aria-label="Page ${pageNumber}">${pageNumber}</a>
                            </li>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < demandesPage.totalPages}">
                                <c:url var="nextPageUrl" value="/demandes">
                                    <c:param name="page" value="${currentPage + 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:if test="${not empty statusFilter}">
                                        <c:param name="status" value="${statusFilter}" />
                                    </c:if>
                                    <c:if test="${not empty searchFilter}">
                                        <c:param name="search" value="${searchFilter}" />
                                    </c:if>
                                    <c:if test="${not empty startDateValue}">
                                        <c:param name="startDate" value="${startDateValue}" />
                                    </c:if>
                                    <c:if test="${not empty endDateValue}">
                                        <c:param name="endDate" value="${endDateValue}" />
                                    </c:if>
                                    <c:if test="${not empty typeVisaValue}">
                                        <c:param name="typeVisa" value="${typeVisaValue}" />
                                    </c:if>
                                </c:url>
                                <li class="page-item page-item-nav">
                                    <a class="page-link" href="${nextPageUrl}" aria-label="Page suivante" title="Page suivante">
                                        <span aria-hidden="true">&gt;</span>
                                        <span class="visually-hidden">Suivant</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item page-item-nav disabled">
                                    <span class="page-link" aria-hidden="true">&gt;</span>
                                    <span class="visually-hidden">Suivant</span>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="status">Aucune demande disponible pour le moment.</div>
        </c:otherwise>
    </c:choose>
</div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var filtersCollapse = document.getElementById('demandeFiltersCollapse');
        if (!filtersCollapse) {
            return;
        }

        var chevronButtons = document.querySelectorAll('.filter-chevron-btn[data-bs-target="#demandeFiltersCollapse"]');

        function syncChevron(isOpen) {
            chevronButtons.forEach(function (button) {
                var icon = button.querySelector('.filter-chevron-icon');
                if (!icon) {
                    return;
                }
                icon.classList.toggle('fa-chevron-up', isOpen);
                icon.classList.toggle('fa-chevron-down', !isOpen);
            });
        }

        syncChevron(filtersCollapse.classList.contains('show'));
        filtersCollapse.addEventListener('shown.bs.collapse', function () {
            syncChevron(true);
        });
        filtersCollapse.addEventListener('hidden.bs.collapse', function () {
            syncChevron(false);
        });
    });
</script>