<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 4 : PIECES COMMUNES -->
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
                            <h3 class="card-title nt-title mb-4"><i class="fas fa-file-alt me-2"></i>Pièces Communes Requises</h3>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape4">
                                <div class="mb-4">
                                    <c:forEach var="piece" items="${piecesCommunas}">
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="piece_${piece.idPiece}" name="piecesCommunesIds"
                                                value="${piece.idPiece}"
                                                <c:if test="${not empty demandeForm.piecesCommunesIds}">
                                                    <c:forEach var="selectedId" items="${demandeForm.piecesCommunesIds}">
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

                                <div class="d-flex gap-2 justify-content-between">
                                    <a href="${pageContext.request.contextPath}/demande/etape3" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Retour
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-arrow-right me-2"></i>Suivant
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
