<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 3 : VISA TRANSFORMABLE -->
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
                            <h3 class="card-title nt-title mb-4"><i class="fas fa-stamp me-2"></i>Visa Transformable</h3>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape3">
                                <input type="hidden" id="idVisaTransformable" name="idVisaTransformable"
                                    value="${not empty demandeForm.idVisaTransformable ? demandeForm.idVisaTransformable : ''}">

                                <div class="mb-4">
                                    <label for="refVisa" class="form-label"><i class="fas fa-barcode me-2"></i>Référence Visa</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="refVisa" name="refVisa"
                                            value="${not empty demandeForm.refVisa ? demandeForm.refVisa : ''}" placeholder="Ex: VISA2025001">
                                        <button class="btn btn-outline-info" type="button" onclick="rechercherVisaTransformable();" title="Rechercher un visa transformable">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label for="dateDebut" class="form-label"><i class="fas fa-calendar-check me-2"></i>Date de début</label>
                                        <input type="date" class="form-control" id="dateDebut" name="dateDebut"
                                            value="${not empty demandeForm.dateDebut ? demandeForm.dateDebut : ''}" >
                                    </div>
                                    <div class="col-md-6">
                                        <label for="dateFin" class="form-label"><i class="fas fa-calendar-check me-2"></i>Date de fin</label>
                                        <input type="date" class="form-control" id="dateFin" name="dateFin"
                                            value="${not empty demandeForm.dateFin ? demandeForm.dateFin : ''}" >
                                    </div>
                                </div>

                                <div class="d-flex gap-2 justify-content-between">
                                    <a href="${pageContext.request.contextPath}/demande/etape2" class="btn btn-outline-secondary">
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

            function rechercherVisaTransformable() {
                const refVisa = document.getElementById('refVisa').value;
                if (refVisa.trim() === '') {
                    alert('Veuillez entrer une référence visa');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/demande/rechercher-visa-transformable?refVisa=' + encodeURIComponent(refVisa);
            }
        </script>