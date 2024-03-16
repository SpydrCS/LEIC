#ifndef AED_PROJ1_BAGAGENS_H
#define AED_PROJ1_BAGAGENS_H

#include <string>
#include "voo.h"
#include "avião.h"

using namespace std;

class Bagagens : public Voo{
public:
    Bagagens(string d, unsigned int p, unsigned int v);
    string getDono();
    unsigned getPeso() const;
    unsigned getVolume() const;
private:
    string dono;
    unsigned peso;
    unsigned volume;
};


#endif //AED_PROJ1_BAGAGENS_H