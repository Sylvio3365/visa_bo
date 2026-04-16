<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="submitUrl" value="/type-visa/ajout" />

<section class="hero">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <div class="pill">Type Visa</div>
            <h1 class="mt-3">Ajouter un type de visa</h1>
            <p class="lead mb-0">Saisissez les informations pour creer un nouveau type.</p>
        </div>
        <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/type-visa' />">Retour a la liste</a>
    </div>
</section>

<div class="card-surface">
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <form method="post" action="${submitUrl}" class="row g-3">
        <div class="col-12 col-md-6">
            <label class="form-label" for="idTypeVisa">Id type visa (auto si vide)</label>
            <input class="form-control" id="idTypeVisa" name="idTypeVisa" type="text" value="${idTypeVisa}" placeholder="TV000001">
            <div class="form-text">Laissez vide pour une generation automatique.</div>
        </div>
        <div class="col-12 col-md-6">
            <label class="form-label" for="libelle">Libelle</label>
            <input class="form-control" id="libelle" name="libelle" type="text" value="${libelle}" required>
        </div>
        <div class="col-12">
            <button class="btn btn-primary" type="submit">Enregistrer</button>
            <a class="btn btn-outline-secondary" href="<c:url value='/type-visa' />">Annuler</a>
        </div>
    </form>
</div>
