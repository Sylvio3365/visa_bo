<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="step" value="${empty currentStep ? 0 : currentStep}"/>
<c:set var="showVisaCarte" value="${not empty demandeForm && (demandeForm.demandCategory eq 'duplicata' || demandeForm.demandCategory eq 'transfert-visa')}"/>
<c:set var="stepNum" value="1"/>
<c:if test="${step eq 'Passport'}"><c:set var="stepNum" value="2"/></c:if>
<c:if test="${step eq 'Visa Transformable'}"><c:set var="stepNum" value="3"/></c:if>
<c:if test="${step eq 'Pieces'}"><c:set var="stepNum" value="4"/></c:if>
<c:if test="${step eq 'Type Visa'}"><c:set var="stepNum" value="5"/></c:if>
<c:if test="${step eq 'Pieces Complementaires'}"><c:set var="stepNum" value="6"/></c:if>
<c:if test="${step eq 'Visa'}"><c:set var="stepNum" value="7"/></c:if>
<c:if test="${step eq 'CarteResidence'}"><c:set var="stepNum" value="8"/></c:if>
<c:if test="${step eq 'Confirmation'}"><c:set var="stepNum" value="9"/></c:if>

<!-- Stepper -->
<div class="row mb-5">
    <div class="col-12">
        <div class="nt-stepper d-flex justify-content-between align-items-center">
            <!-- Étape 1: État Civil -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape1';">
                <div class="step-circle ${stepNum == 1 ? 'active' : stepNum > 1 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 1 ? 'fa-check' : 'fa-user'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Etat Civil</small>
            </div>
            <div class="step-line ${stepNum > 1 ? 'completed' : stepNum == 1 ? 'active' : ''}"></div>

            <!-- Étape 2: Passeport -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape2';">
                <div class="step-circle ${stepNum == 2 ? 'active' : stepNum > 2 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 2 ? 'fa-check' : 'fa-passport'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Passeport</small>
            </div>
            <div class="step-line ${stepNum > 2 ? 'completed' : stepNum == 2 ? 'active' : ''}"></div>

            <!-- Étape 3: Visa -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape3';">
                <div class="step-circle ${stepNum == 3 ? 'active' : stepNum > 3 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 3 ? 'fa-check' : 'fa-stamp'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Visa</small>
            </div>
            <div class="step-line ${stepNum > 3 ? 'completed' : stepNum == 3 ? 'active' : ''}"></div>

            <!-- Étape 4: Pièces -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape4';">
                <div class="step-circle ${stepNum == 4 ? 'active' : stepNum > 4 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 4 ? 'fa-check' : 'fa-file-alt'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Pieces communes</small>
            </div>
            <div class="step-line ${stepNum > 4 ? 'completed' : stepNum == 4 ? 'active' : ''}"></div>

            <!-- Étape 5: Type Visa -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape5';">
                <div class="step-circle ${stepNum == 5 ? 'active' : stepNum > 5 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 5 ? 'fa-check' : 'fa-id-card'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Type Visa</small>
            </div>
            <div class="step-line ${stepNum > 5 ? 'completed' : stepNum == 5 ? 'active' : ''}"></div>

            <!-- Étape 6: Complémentaires -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape6';">
                <div class="step-circle ${stepNum == 6 ? 'active' : stepNum > 6 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 6 ? 'fa-check' : 'fa-check-circle'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Pieces complementaires</small>
            </div>

            <div class="step-line ${stepNum > 6 ? 'completed' : stepNum == 6 ? 'active' : ''}"></div>

            <c:if test="${showVisaCarte}">
                <!-- Étape 7: Visa -->
                <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape7';">
                    <div class="step-circle ${stepNum == 7 ? 'active' : stepNum > 7 ? 'completed' : ''}">
                        <i class="fas ${stepNum > 7 ? 'fa-check' : 'fa-stamp'}"></i>
                    </div>
                    <small class="nt-step-label d-block mt-2">Visa</small>
                </div>
                <div class="step-line ${stepNum > 7 ? 'completed' : stepNum == 7 ? 'active' : ''}"></div>

                <!-- Étape 8: Carte Résidence -->
                <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/etape8';">
                    <div class="step-circle ${stepNum == 8 ? 'active' : stepNum > 8 ? 'completed' : ''}">
                        <i class="fas ${stepNum > 8 ? 'fa-check' : 'fa-id-card'}"></i>
                    </div>
                    <small class="nt-step-label d-block mt-2">Carte Résidence</small>
                </div>
                <div class="step-line ${stepNum > 8 ? 'completed' : stepNum == 8 ? 'active' : ''}"></div>
            </c:if>

            <!-- Étape 9: Confirmation -->
            <div class="nt-step-item text-center flex-grow-1 nt-step-clickable" onclick="window.location.href='${pageContext.request.contextPath}/demande/confirmation';">
                <div class="step-circle ${stepNum == 9 ? 'active' : stepNum > 9 ? 'completed' : ''}">
                    <i class="fas ${stepNum > 9 ? 'fa-check' : 'fa-check'}"></i>
                </div>
                <small class="nt-step-label d-block mt-2">Confirmation</small>
            </div>
        </div>
    </div>
</div>
