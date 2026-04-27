<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .history-timeline {
        position: relative;
        padding-left: 3rem;
        margin-top: 2rem;
    }

    .history-timeline::before {
        content: '';
        position: absolute;
        left: 0.75rem;
        top: 0;
        bottom: 0;
        width: 2px;
        background: #e2e8f0;
    }

    .history-item {
        position: relative;
        margin-bottom: 2.5rem;
    }

    .history-marker {
        position: absolute;
        left: -3rem;
        width: 1.5rem;
        height: 1.5rem;
        border-radius: 50%;
        background: #fff;
        border: 2px solid var(--accent, #0c8a7b);
        z-index: 1;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .history-item:first-child .history-marker {
        background: var(--accent, #0c8a7b);
        box-shadow: 0 0 0 4px rgba(12, 138, 123, 0.2);
    }

    .history-item:first-child .history-marker i {
        color: #fff;
        font-size: 0.7rem;
    }

    .history-content {
        background: #fff;
        border-radius: 0.8rem;
        padding: 1.25rem;
        border: 1px solid #e2e8f0;
        transition: all 0.2s ease;
    }

    .history-content:hover {
        border-color: var(--accent, #0c8a7b);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .history-date {
        font-size: 0.85rem;
        color: #64748b;
        font-weight: 600;
        margin-bottom: 0.25rem;
    }

    .history-status {
        font-weight: 700;
        color: #1e293b;
        font-size: 1.1rem;
        margin-bottom: 0.5rem;
    }

    .history-user {
        font-size: 0.85rem;
        color: #475569;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .history-id {
        font-family: monospace;
        font-size: 0.75rem;
        color: #94a3b8;
    }
</style>

<div class="container nt-page">
    <div class="nt-page-head d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="nt-page-title"><i class="fas fa-history me-2"></i>Historique des statuts</h1>
            <p class="nt-page-subtitle">Suivi du cycle de vie de la demande <strong>${idDemande}</strong></p>
        </div>
        <a href="${pageContext.request.contextPath}/demandes/${idDemande}" class="btn btn-outline-secondary px-4 border-0 shadow-sm" style="background: #f1f5f9; color: #475569; border-radius: 0.8rem;">
            <i class="fas fa-arrow-left me-2"></i>Retour aux détails
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0" style="border-radius: 1rem;">
                <div class="card-body p-4 p-md-5">
                    <c:choose>
                        <c:when test="${not empty historique}">
                            <div class="history-timeline">
                                <c:forEach items="${historique}" var="statut" varStatus="loop">
                                    <div class="history-item">
                                        <div class="history-marker">
                                            <c:if test="${loop.first}"><i class="fas fa-check"></i></c:if>
                                        </div>
                                        <div class="history-content">
                                            <div class="d-flex justify-content-between align-items-start border-bottom pb-2 mb-2">
                                                <div>
                                                    <div class="history-date">
                                                        <i class="far fa-calendar-alt me-1"></i>
                                                        ${statut.date}
                                                    </div>
                                                    <div class="history-status">${statut.statut.libelle}</div>
                                                </div>
                                                <div class="history-id">#${statut.idStatutDemande}</div>
                                            </div>
                                            <div class="history-user">
                                                <i class="fas fa-user-circle"></i>
                                                <span>Modifié automatiquement par le système</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-history fa-3x mb-3 text-muted"></i>
                                <p class="lead text-muted">Aucun historique disponible pour cette demande.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
