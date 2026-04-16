<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="typeVisaUrl" value="/type-visa" />

<section class="hero">
    <div class="pill">Backoffice</div>
    <h1 class="mt-3">Pilotage des dossiers visa</h1>
    <p class="lead mb-4">Centralisez les types de visa, demandes et statuts dans une interface claire.</p>
    <div class="cta-row">
        <a class="btn btn-primary btn-lg" href="${typeVisaUrl}">Voir les types de visa</a>
        <a class="btn btn-outline-dark btn-lg" href="#">Creer une demande</a>
    </div>
</section>

<section class="grid-panels">
    <div class="card-surface">
        <div class="panel-title">Suivi rapide</div>
        <p class="panel-text">Accedez aux listes principales et lancez les actions courantes.</p>
        <a class="btn btn-outline-primary btn-sm" href="${typeVisaUrl}">Ouvrir la liste</a>
    </div>
    <div class="card-surface">
        <div class="panel-title">Priorites</div>
        <p class="panel-text">Mettez en avant les dossiers urgents et les validations en attente.</p>
        <a class="btn btn-outline-secondary btn-sm" href="#">Configurer</a>
    </div>
</section>
