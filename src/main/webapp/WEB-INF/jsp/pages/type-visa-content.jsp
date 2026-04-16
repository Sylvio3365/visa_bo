<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="typeVisaUrl" value="/type-visa" />
<section class="hero">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <div class="pill">Type Visa</div>
            <h1 class="mt-3">Liste des types de visa</h1>
            <p class="lead mb-0">Vue simple pour consulter les types de visa disponibles.</p>
        </div>
        <a class="btn btn-outline-success btn-sm" href="${typeVisaUrl}">Recharger</a>
    </div>
</section>

<div class="card-surface">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <h2 class="h5 mb-0">Tableau</h2>
        <c:if test="${not empty types}">
            <span class="status">${types.size()} element(s) charge(s).</span>
        </c:if>
    </div>
    <div class="table-responsive mt-3">
        <table class="table table-hover align-middle">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Libelle</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="typeVisa" items="${types}">
                    <tr>
                        <td>${typeVisa.idTypeVisa}</td>
                        <td>${typeVisa.libelle}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <c:if test="${empty types}">
        <div class="status">Aucun type de visa trouve.</div>
    </c:if>
</div>
