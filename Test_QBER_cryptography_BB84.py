from random import*
import random

def algocrypto(n,mi):
    a=[]
    for k in range(n):#On simule les mesures de polarisations d'Alice
        a.append(randint(1,4))
    e=[]
    for k in range(n):#On simule les mesures de polarisations d'Eve
        z=randint(1,4)
        if a[k]%2==0:
            if z%2==0:#Alice et Eve ont la même orientation
                e.append(a[k])
            else:#Alice et Eve n'ont pas la même orientation
                e.append(z)
        else:
            if z%2==1:
                e.append(a[k])
            else:
                e.append(z)
    b=[]
    for k in range(n):#On simule les mesures de polarisations de Bob
        z=randint(1,4)
        if e[k]%2==0:
            if z%2==0:#Bob et Eve ont la même orientation
                b.append(e[k])
            else:#Bob et Eve n'ont pas la même orientation
                b.append(z)
        else:
            if z%2==1:
                b.append(e[k])
            else:
                b.append(z)
    A=[]
    B=[]
    for k in range(n):#On fait la liste des mesures de même orientation
        if a[k]%2==0 and b[k]%2==0:
            A.append(a[k])
            B.append(b[k])
        else:
            if a[k]%2==1 and b[k]%2==1:
                A.append(a[k])
                B.append(b[k])
    m=min(mi,len(A))#Pour ne pas avoir plus de qubits à tester qu'on en a de
                    #même orientation
    o=[k for k in range(m)]
    numtest=random.sample(o,m)#On choisit au hasard des qubits pour le test
    test=[]
    for k in numtest:
        if A[k]==B[k]:
            test.append(1)
        else:
            test.append(0)
    acc=0
    for k in test:
        acc+=k
    return acc/m#On retourne le ratio des coïncidences.







#Commentaires :
#-> Si Eve a la même orientation que Bob, alors la polarisation de Bob est celle
#   d'Eve ( on ne s'occupe pas de celui d'Alice )
#-> Si Eve n'a pas la même orientation que Bob, alors :
#   * Soit Alice et Bob ont la même orientation, mais par forcage d'Eve la
#     la polarisation pour Bob sera aléatiore
#   * Soit Alice et Bob n'ont pas la même orientation et alors Bob aura une
#     polarisation aléatoire
#On voit bien qu'il n'y a finalement que deux cas( pour savoir si Bob a ou
#non une polarisation aléatoire ) : soit Bob a la polarisation d'Eve ( et
#possiblement celle d'Alice, mais ça n'a pas d'importance pour l'algorithme ),
#soit il ne l'a pas et alors elle sera aléatoire. On se fiche ici ( quand on
#connait celle d'Eve ) éperdument de la polarisation d'Alice.

def compte(n,npho,nctrl):
    lmaxi,lacc,lmoy=[],[],[]
    for k in range(4,nctrl+1,4):
        maxi=0#Maximum des ratios
        acc=0#Nombre de ratios > à 0,89
        moy=0#Moyenne des ratios
        for j in range(n):
            a=algocrypto(npho,k)
            if a>0.89:acc+=1
            maxi=max(maxi,a)
            moy+=a
        lmaxi.append(maxi)
        lacc.append(acc)
        lmoy.append(moy/n)
    return lacc,lmaxi,lmoy

#n : Nombre de répétitions ; npho ; nombre de photons
#échangés ; nctrl : nombre de photons dans l'échantilon de contrôle
