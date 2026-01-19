package com.agriiot.agridata.model;
import jakarta.persistence.*;
import java.time.LocalDateTime;
@Entity
public class Mesure {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime dateMesure;
    private double valeur;
    private String typeMesure;
    @ManyToOne
    @JoinColumn(name = "capteur_id")
    private Capteur capteur;
    public Mesure() {}
    public Mesure(LocalDateTime dateMesure, double valeur, String typeMesure, Capteur capteur) {
        this.dateMesure = dateMesure;
        this.valeur = valeur;
        this.typeMesure = typeMesure;
        this.capteur = capteur;
    }
    public Long getId() { return id; }
    public LocalDateTime getDateMesure() { return dateMesure; }
    public void setDateMesure(LocalDateTime dateMesure) { this.dateMesure = dateMesure; }
    public double getValeur() { return valeur; }
    public void setValeur(double valeur) { this.valeur = valeur; }
    public String getTypeMesure() { return typeMesure; }
    public void setTypeMesure(String typeMesure) { this.typeMesure = typeMesure; }
    public Capteur getCapteur() { return capteur; }
    public void setCapteur(Capteur capteur) { this.capteur = capteur; }
}