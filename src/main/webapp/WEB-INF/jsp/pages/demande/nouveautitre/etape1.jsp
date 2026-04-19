<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_nouveau_titre.css">

        <!-- ETAPE 1 : ETAT CIVIL -->
        <div class="container nt-page">
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
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                                <h3 class="card-title nt-title mb-0"><i class="fas fa-user-circle me-2"></i>Informations Civiles</h3>
                                <button type="button" class="btn btn-outline-secondary" onclick="document.getElementById('searchSection').style.display = document.getElementById('searchSection').style.display === 'none' ? 'block' : 'none';">
                                    <i class="fas fa-search me-2"></i>Charger un demandeur
                                </button>
                            </div>

                            <div style="display: none;" id="searchSection" class="alert alert-info mb-4">
                                <h5><i class="fas fa-search me-2"></i>Rechercher une demande existante</h5>
                                <div class="input-group mt-3">
                                    <input type="text" id="searchId" class="form-control" placeholder="N° ID du demandeur (ex: DM000001)">
                                    <button class="btn btn-outline-primary" type="button" onclick="rechercherDemandeur();">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>

                            <form method="POST" action="${pageContext.request.contextPath}/demande/etape1">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="nom" class="form-label"><i class="fas fa-font me-2"></i>Nom</label>
                                        <input type="text" class="form-control" id="nom" name="nom"
                                            value="${not empty demandeForm.nom ? demandeForm.nom : ''}" >
                                    </div>
                                    <div class="col-md-6">
                                        <label for="prenom" class="form-label"><i class="fas fa-font me-2"></i>Prénom</label>
                                        <input type="text" class="form-control" id="prenom" name="prenom"
                                            value="${not empty demandeForm.prenom ? demandeForm.prenom : ''}" >
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="nomJeuneFille" class="form-label"><i class="fas fa-font me-2"></i>Nom de jeune fille</label>
                                    <input type="text" class="form-control" id="nomJeuneFille" name="nomJeuneFille"
                                        value="${not empty demandeForm.nomJeuneFille ? demandeForm.nomJeuneFille : ''}">
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="dtn" class="form-label"><i class="fas fa-calendar me-2"></i>Date de naissance</label>
                                        <input type="date" class="form-control" id="dtn" name="dtn"
                                            value="${not empty demandeForm.dtn ? demandeForm.dtn : ''}" >
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                            value="${not empty demandeForm.email ? demandeForm.email : ''}" >
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="telephone" class="form-label"><i class="fas fa-phone me-2"></i>Téléphone</label>
                                        <input type="tel" class="form-control" id="telephone" name="telephone"
                                            value="${not empty demandeForm.telephone ? demandeForm.telephone : ''}">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="idNationalite" class="form-label"><i class="fas fa-globe me-2"></i>Nationalité</label>
                                        <select id="idNationalite" name="idNationalite" class="form-select" >
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="nat" items="${nationalites}">
                                                <option value="${nat.idNationalite}" ${demandeForm.idNationalite eq nat.idNationalite ? 'selected' : '' }>
                                                    ${nat.flag} ${nat.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="idSituationFamille" class="form-label"><i class="fas fa-home me-2"></i>Situation familiale</label>
                                        <select id="idSituationFamille" name="idSituationFamille" class="form-select" >
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="sf" items="${situation_familles}">
                                                <option value="${sf.idSituationFamille}" ${demandeForm.idSituationFamille eq sf.idSituationFamille ? 'selected' : '' }>
                                                    ${sf.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="adresseMada" class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Adresse (Madagascar)</label>
                                    <textarea id="adresseMada" name="adresseMada" class="form-control" rows="2"
                                        placeholder="Entrez votre adresse">${not empty demandeForm.adresseMada ? demandeForm.adresseMada : ''}</textarea>
                                </div>

                                <div class="d-flex gap-2 justify-content-end">
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

            function rechercherDemandeur() {
                const searchId = document.getElementById('searchId').value;
                if (searchId.trim() === '') {
                    alert('Veuillez entrer un N° ID du demandeur');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/demande/rechercher-demandeur?searchId=' + encodeURIComponent(searchId);
            }
        </script>