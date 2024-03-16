#ifndef AED_PROJ1_BILHETE_H
#define AED_PROJ1_BILHETE_H

#include <string>
#include "voo.h"

using namespace std;

class Bilhete : public Voo {
private:
    bool checkinAutomatico;
    bool bagagens;
    string nomeDono;
    unsigned quantidade_bagagens;
    unsigned quantidade_bilhetes;
public:
    Bilhete(string m, bool cA, bool b, string nD, unsigned int q_bag, unsigned int q_bilh);
    bool getCheckInAutomatico() const;
    bool getBagagens() const;
    string getNomeDono();
    unsigned getQuantidadeBagagens() const;
    unsigned getQuantidadeBilhetes() const;
    bool BilheteValido();
    void updateVagas();
};

#endif //AED_PROJ1_BILHETE_H
