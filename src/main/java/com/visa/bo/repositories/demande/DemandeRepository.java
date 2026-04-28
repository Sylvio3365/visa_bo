package com.visa.bo.repositories.demande;

import java.util.Optional;
import java.util.List;
import java.time.LocalDate;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.visa.bo.models.demande.Demande;

public interface DemandeRepository extends JpaRepository<Demande, String> {

		interface DemandeListItemProjection {
				Demande getDemande();

				String getStatut();

				String getIdStatut();
		}

		@Query(value = """
						select d as demande, s.libelle as statut, s.idStatut as idStatut
						from Demande d
						left join d.demandeur dm
						left join d.typeVisa tv
						left join StatutDemande sd on sd.demande = d
								and sd.idStatutDemande = (
										select max(sd2.idStatutDemande)
										from StatutDemande sd2
										where sd2.demande = d
								)
						left join sd.statut s
						where (:statusFilter is null or lower(s.libelle) = lower(cast(:statusFilter as string)))
							and d.createdAt >= :startDate
							and d.createdAt <= :endDate
							and (:typeVisaFilter is null or tv.idTypeVisa = :typeVisaFilter)
							and (
								:searchFilter is null
								or lower(d.idDemande) like lower(concat('%', cast(:searchFilter as string), '%'))
								or lower(concat(concat(coalesce(dm.nom, ''), ' '), coalesce(dm.prenom, ''))) like lower(concat('%', cast(:searchFilter as string), '%'))
							)
						order by d.createdAt desc, d.idDemande desc
						""", countQuery = """
						select count(d)
						from Demande d
						left join d.demandeur dm
						left join d.typeVisa tv
						left join StatutDemande sd on sd.demande = d
								and sd.idStatutDemande = (
										select max(sd2.idStatutDemande)
										from StatutDemande sd2
										where sd2.demande = d
								)
						left join sd.statut s
						where (:statusFilter is null or lower(s.libelle) = lower(cast(:statusFilter as string)))
							and d.createdAt >= :startDate
							and d.createdAt <= :endDate
							and (:typeVisaFilter is null or tv.idTypeVisa = :typeVisaFilter)
							and (
								:searchFilter is null
								or lower(d.idDemande) like lower(concat('%', cast(:searchFilter as string), '%'))
								or lower(concat(concat(coalesce(dm.nom, ''), ' '), coalesce(dm.prenom, ''))) like lower(concat('%', cast(:searchFilter as string), '%'))
							)
						""")
		Page<DemandeListItemProjection> findPageWithLatestStatus(
				Pageable pageable,
				@Param("statusFilter") String statusFilter,
				@Param("searchFilter") String searchFilter,
				@Param("startDate") LocalDate startDate,
				@Param("endDate") LocalDate endDate,
				@Param("typeVisaFilter") String typeVisaFilter);

		@Query("""
				select distinct s.libelle
				from StatutDemande sd
				join sd.statut s
				where s.libelle is not null and trim(s.libelle) <> ''
				order by s.libelle asc
				""")
		List<String> findDistinctStatusLabels();

		@EntityGraph(attributePaths = { "demandeur", "typeVisa", "categorie", "passport", "visaTransformable" })
		@Query("select d from Demande d where d.idDemande = :idDemande")
		Optional<Demande> findDetailedByIdDemande(@Param("idDemande") String idDemande);

		@Query("""
						select s.libelle
						from StatutDemande sd
						join sd.statut s
						where sd.demande.idDemande = :idDemande
							and sd.idStatutDemande = (
								select max(sd2.idStatutDemande)
								from StatutDemande sd2
								where sd2.demande.idDemande = :idDemande
							)
						""")
		Optional<String> findLatestStatusLabelByDemandeId(@Param("idDemande") String idDemande);

		@Query("""
					select s.idStatut
					from StatutDemande sd
					join sd.statut s
					where sd.demande.idDemande = :idDemande
						and sd.idStatutDemande = (
							select max(sd2.idStatutDemande)
							from StatutDemande sd2
							where sd2.demande.idDemande = :idDemande
						)
					""")
		Optional<String> findLatestStatusIdByDemandeId(@Param("idDemande") String idDemande);

				Optional<Demande> findTopByDemandeurIdDemandeurOrderByCreatedAtDescIdDemandeDesc(String idDemandeur);

}
