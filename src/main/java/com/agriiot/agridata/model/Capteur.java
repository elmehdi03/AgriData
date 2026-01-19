package com.agriiot.agridata.model;
import jakarta.persistence.*;
import java.util.List;
@Entity
public class Capteur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nom;
    private String type;
    private String localisation;
    @OneToMany(mappedBy = "capteur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Mesure> mesures;
    public Capteur() {}
    public Capteur(String nom, String type, String localisation) {
        this.nom = nom;
        this.type = type;
        this.localisation = localisation;
    }
    public Long getId() { return id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getLocalisation() { return localisation; }
    public void setLocalisation(String localisation) { this.localisation = localisation; }
    public List<Mesure> getMesures() { return mesures; }
    public void setMesures(List<Mesure> mesures) { this.mesures = mesures; }
}