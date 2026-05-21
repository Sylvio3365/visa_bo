<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accusé de réception - Demande de Visa</title>
    <!-- Bootstrap CSS for layout -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Times New Roman', serif; /* Official look */
        }
        .receipt-container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            padding: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #ddd;
        }
        .header {
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h2 {
            margin: 0;
            font-weight: bold;
            text-transform: uppercase;
        }
        .header h4 {
            margin-top: 5px;
            color: #555;
        }
        .details-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
        }
        .applicant-info {
            width: 60%;
        }
        .photo-section {
            width: 35%;
            text-align: right;
        }
        .photo-section img {
            max-width: 150px;
            border: 1px solid #ccc;
            padding: 5px;
        }
        .qr-section {
            text-align: center;
            margin-top: 50px;
            border-top: 1px dashed #ccc;
            padding-top: 30px;
        }
        .qr-section img {
            max-width: 200px;
        }
        .footer {
            margin-top: 50px;
            font-size: 0.9rem;
            color: #777;
            text-align: center;
        }
        .table-details {
            width: 100%;
            margin-bottom: 20px;
        }
        .table-details th {
            text-align: left;
            width: 40%;
            padding: 8px 0;
            color: #555;
            font-weight: normal;
        }
        .table-details td {
            font-weight: bold;
            padding: 8px 0;
        }
        
        @media print {
            body {
                background: none;
            }
            .receipt-container {
                margin: 0;
                padding: 0;
                box-shadow: none;
                border: none;
            }
        }
    </style>
</head>
<body onload="window.print()">

    <div class="receipt-container">
        <div class="header">
            <h2>République de Madagascar</h2>
            <h4>Ministère des Affaires Étrangères</h4>
            <div style="margin-top: 20px;">
                <h3 style="text-decoration: underline;">ACCUSÉ DE RÉCEPTION</h3>
            </div>
        </div>

        <div class="details-section">
            <div class="applicant-info">
                <table class="table-details">
                    <tr>
                        <th>N° de la demande :</th>
                        <td>${demande.idDemande}</td>
                    </tr>
                    <tr>
                        <th>Date de création :</th>
                        <td>${demande.createdAt}</td>
                    </tr>
                    <tr>
                        <th>Nom(s) :</th>
                        <td>${demande.demandeur.nom}</td>
                    </tr>
                    <tr>
                        <th>Prénom(s) :</th>
                        <td>${demande.demandeur.prenom}</td>
                    </tr>
                    <tr>
                        <th>Date de naissance :</th>
                        <td>${demande.demandeur.dtn}</td>
                    </tr>
                    <tr>
                        <th>N° de Passeport :</th>
                        <td>${demande.passport.numero}</td>
                    </tr>
                    <tr>
                        <th>Type de Visa :</th>
                        <td>${demande.typeVisa.libelle}</td>
                    </tr>
                </table>
            </div>

            <div class="photo-section">
                <c:if test="${not empty demande.demandeur.photo}">
                    <img src="${demande.demandeur.photo}" alt="Photo d'identité">
                </c:if>
                <c:if test="${empty demande.demandeur.photo}">
                    <div style="width: 150px; height: 190px; border: 1px solid #ccc; display: inline-block; background: #eee; text-align: center; line-height: 190px; color: #999;">
                        Pas de photo
                    </div>
                </c:if>
            </div>
        </div>

        <div style="margin-top: 30px;">
            <p>Cet accusé de réception confirme la soumission et la réception de votre dossier de demande de visa. 
               Il doit être conservé et présenté lors de vos démarches ultérieures.</p>
        </div>

        <div class="qr-section">
            <h5>QR Code de suivi de votre demande</h5>
            <p style="font-size: 0.85rem; color: #666;">Scannez ce QR Code pour vérifier le statut de votre demande.</p>
            <img src="${pageContext.request.contextPath}/demandes/${demande.idDemande}/qr" alt="QR Code">
        </div>

        <div class="footer">
            <p>Document généré automatiquement par le système e-Visa Back-Office.</p>
        </div>
    </div>

</body>
</html>
