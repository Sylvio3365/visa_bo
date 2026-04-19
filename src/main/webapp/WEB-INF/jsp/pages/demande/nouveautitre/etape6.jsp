<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 6 : PIECES COMPLEMENTAIRES -->
        <div class="container mt-4 nt-page">
            <div class="nt-page-head">
                <h1 class="nt-page-title"><i class="fas fa-pen-nib me-2"></i>Nouvelle demande de titre de visa</h1>
                <p class="nt-page-subtitle">Renseignez les informations de création du dossier.</p>
            </div>

            <!-- Stepper -->
            <jsp:include page="fragments/stepper.jsp" />

            <div class="row">
                <div class="">
                    <div class="card shadow-sm nt-form-card">
                        <div class="card-body p-4">
                            <h3 class="card-title nt-title mb-4"><i class="fas fa-file me-2"></i>Pièces Complémentaires</h3>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape6">
                                <c:choose>
                                    <c:when test="${not empty piecesComplementaires}">
                                        <div class="mb-4">
                                            <c:forEach var="piece" items="${piecesComplementaires}">
                                                <div class="form-check mb-3">
                                                    <input class="form-check-input" type="checkbox" id="piece_${piece.idPiece}" name="piecesComplementairesIds"
                                                        value="${piece.idPiece}" <c:if test="${not empty demandeForm.piecesComplementairesIds}">
                                                        <c:forEach var="selectedId" items="${demandeForm.piecesComplementairesIds}">
                                                            <c:if test="${selectedId == piece.idPiece}">checked</c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    >
                                                    <label class="form-check-label" for="piece_${piece.idPiece}">
                                                        <i class="fas fa-file me-2"></i>${piece.libelle}
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info" role="alert">
                                            <i class="fas fa-info-circle me-2"></i>Aucune pièce complémentaire requise pour ce type de visa.
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="d-flex gap-2 justify-content-between">
                                    <a href="${pageContext.request.contextPath}/demande/etape5" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Retour
                                    </a>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-check me-2"></i>Confirmer et Terminer
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const errorMessage = `<c:out value="${errorMessage}" escapeXml="false"/>`;
            if (errorMessage.trim() !== '') {
                alert(errorMessage);
            }
        </script>