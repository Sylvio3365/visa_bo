<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 2 : PASSEPORT -->
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
                            <h3 class="card-title nt-title mb-4"><i class="fas fa-passport me-2"></i>Informations du Passeport</h3>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape2">
                                <div class="mb-4">
                                    <label for="numPassport" class="form-label"><i class="fas fa-barcode me-2"></i>Numéro de passeport</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="numPassport" name="numPassport"
                                            value="${not empty demandeForm.numPassport ? demandeForm.numPassport : ''}" placeholder="Ex: PASS2025">
                                        <button class="btn btn-outline-info" type="button" onclick="rechercherPassport();" title="Rechercher un passeport existant">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label for="dateDelivrancePassport" class="form-label"><i class="fas fa-calendar-plus me-2"></i>Date de délivrance</label>
                                        <input type="date" class="form-control" id="dateDelivrancePassport" name="dateDelivrancePassport"
                                            value="${not empty demandeForm.dateDelivrancePassport ? demandeForm.dateDelivrancePassport : ''}" >
                                    </div>
                                    <div class="col-md-6">
                                        <label for="dateExpirationPassport" class="form-label"><i class="fas fa-calendar-times me-2"></i>Date d'expiration</label>
                                        <input type="date" class="form-control" id="dateExpirationPassport" name="dateExpirationPassport"
                                            value="${not empty demandeForm.dateExpirationPassport ? demandeForm.dateExpirationPassport : ''}" >
                                    </div>
                                </div>

                                <div class="d-flex gap-2 justify-content-between">
                                    <a href="${pageContext.request.contextPath}/demande/etape1" class="btn btn-outline-secondary">
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

            function rechercherPassport() {
                const numPassport = document.getElementById('numPassport').value;
                if (numPassport.trim() === '') {
                    alert('Veuillez entrer un numéro de passeport');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/demande/rechercher-passport?numPassport=' + encodeURIComponent(numPassport);
            }
        </script>