<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 5 : TYPE DE VISA -->
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
                            <h3 class="card-title nt-title mb-4"><i class="fas fa-id-card me-2"></i>Sélection du Type de Visa</h3>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape5">
                                <div class="mb-4">
                                    <label for="idTypeVisa" class="form-label"><i class="fas fa-list me-2"></i>Type de visa</label>
                                    <select id="idTypeVisa" name="idTypeVisa" class="form-select form-select">
                                        <option value="">-- Sélectionner un type de visa --</option>
                                        <c:forEach var="typeVisa" items="${typesVisa}">
                                            <option value="${typeVisa.idTypeVisa}" ${demandeForm.idTypeVisa eq typeVisa.idTypeVisa ? 'selected' : '' }>
                                                ${typeVisa.libelle}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="d-flex gap-2 justify-content-between">
                                    <a href="${pageContext.request.contextPath}/demande/etape4" class="btn btn-outline-secondary">
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