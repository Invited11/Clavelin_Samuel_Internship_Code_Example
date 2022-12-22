program name

    Implicit None

    Integer(4),parameter::PR=8
    Real(PR),dimension(6,6)::O,C,C_KM
    Real(PR),dimension(5,6)::A
    Real(PR),dimension(:),allocatable::AA
    Integer(PR),dimension(:),allocatable::JA,IA
    Real(PR),dimension(6)::v
    Integer(PR)::i,nb

    O=0

    A=0
    A(1,1)=1
    A(1,4)=2
    A(2,2)=3
    A(2,4)=4
    A(2,6)=5
    A(3,4)=6
    A(3,5)=7
    A(4,1)=8
    A(4,4)=9
    A(4,5)=10
    A(5,2)=11
    A(5,4)=12
    A(5,6)=13

    C=0
    Do i=1,5
        C(i,i)=1
        C(i+1,i)=-1
    End Do
    C(6,6)=1
    C(1,6)=-1

    v=0
    v(6)=1

    nb=Compte(C)
    Allocate(AA(nb),JA(nb),IA(Size(C,1)+1))
        Call CSR(C,nb,AA,JA,IA)
        C_KM=KM(C)
        Do i=1,6
            Print *,C_KM(i,:)
        End Do

        Print *,Prod_CSR_Vec(AA,JA,IA,v)

    Deallocate(AA,JA,IA)

    Contains

    Function Compte(M)Result(acc)

        Real(PR),dimension(:,:),Intent(In)::M
        Integer(PR)::acc,i,j

        acc=0

        Do i=1,Size(M,1)
            Do j=1,Size(M,2)
                If(.NOT. abs(M(i,j))<10._PR**(-10))Then
                    acc=acc+1
                End If
            End Do
        End Do

    End Function Compte

    Subroutine CSR(M,nb_coeff_nn_nuls,MM,JM,IM)

        Real(PR),dimension(:,:),Intent(In)::M
        Integer(PR),Intent(In)::nb_coeff_nn_nuls
        Real(PR),dimension(nb_coeff_nn_nuls),Intent(out)::MM
        Integer(PR),dimension(nb_coeff_nn_nuls),Intent(out)::JM
        Integer(PR),dimension(Size(M,1)+1),Intent(out)::IM
        Integer(PR)::i,j,n,acc,acc2
        !MM : valeur coeff non nuls
        !IM : nombre coeff non-nuls
        !JM : colonnes coeff non-nuls
        
        n=Size(M,1)
        acc=1
        acc2=1
        IM(acc)=1
        Do i=1,Size(M,1)
            Do j=1,Size(M,2)
                If(.NOT. abs(M(i,j))<10._PR**(-10)) Then
                MM(acc)=M(i,j)
                JM(acc)=j
                acc2=acc2+1
                acc=acc+1
                End If
            End Do
            IM(i+1)=acc2
        End Do

    End Subroutine CSR

    Function Dirac(a,x)Result(res) ! Renvoie 1 si x=a et 0 sinon

        Real(PR),Intent(In)::a,x
        Integer(PR)::res

        If(abs(a-x)<10._PR**(-10))Then
            res=1
        Else
            res=0
        End If

    End Function Dirac

    Subroutine Tri_bulle(l,perm) ! Trie l et renvoie la liste des permutations ; tri bulle car facile à coder en F90 et est stable ( préserve l'ordre des éléments égaux )

        Integer(PR),dimension(:),Intent(InOut)::l
        Integer(PR),dimension(Size(l)),Intent(Out)::perm
        Integer(PR)::mem
        Integer(PR)::i,j,n

        n=Size(l)
        Do i=1,n
            perm(i)=i
        End Do

        Do i=1,n-1 ! n-1 car sinon problème dans définition de j
            Do j=1,n-i ! n-i car pour i=1, on a chopé le plus grand élément de l et on l'a mis à la fin donc pour i=2 on n'a besoin d'aller que jusqu'à n-1 élément
                If(l(j)>l(j+1))Then
                    mem=l(j)
                    l(j)=l(j+1)
                    l(j+1)=mem
                    mem=perm(j)
                    perm(j)=perm(j+1)
                    perm(j+1)=mem
                End If
            End Do
        End Do

    End Subroutine Tri_bulle

    Function Est_Dans(x,l)Result(bool) ! Dit si x est dans l

        Integer(PR),Intent(In)::x
        Integer(PR),dimension(:),Intent(In)::l
        Logical::bool
        Integer(PR)::i
        
        bool=.False.

        Do i=1,Size(l)
            bool=bool.OR.(x==l(i))
        End Do

    End Function Est_Dans

    Function Premier0(l)Result(n) ! Indice du permier 0 d'une liste

        Integer(PR),dimension(:),Intent(In)::l
        Integer(PR)::n

        n=1
        Do While((n<Size(l)).AND..NOT.(l(n)==0))
            n=n+1
        End Do

    End Function Premier0

    Subroutine Renum(l,deg,M,ll) ! Prend en argument l triée, deg(i) le degré de l(i) et M une matrice des liens entre étiquettes et renvoie ll ordonnée selon KM

        Integer(PR),dimension(:),Intent(In)::l,deg
        Integer(PR),dimension(:,:),Intent(In)::M
        Integer(PR),dimension(Size(l)),Intent(Out)::ll
        Integer(PR)::i,j,n,acc0,prem0,k ! prem0 : indice du premier 0 dans ll
        Logical::bool

        n=Size(l)
        ll=0
        acc0=0
        Do i=1,n
            If (deg(i)==0)Then
                ll(1+acc0)=l(i)
                acc0=acc0+1
            End If
        End Do

        Do i=1,n
            Do j=1,n ! Peut-être seulement jusqu'à n-acc0, pour optimiser
                bool=((M(l(i),l(j))==1)).OR.((M(l(j),l(i))==1))
                If(bool.AND.(.NOT.Est_Dans(l(j),ll)))Then ! l(1) : sommet de plus haut degré, l(n) de plus bas ; if <=> si l(i) en lien avec l(j) et si l(j) pas déjà marqué alors ...
                    prem0=Premier0(ll)
                    ll(prem0)=l(j) ! On place l(j) à la suite des autres
                End If
            End Do
            prem0=Premier0(ll)
            j=1
            Do While(j<prem0) ! Tant qu'on n'est pas à une case de ll vide, on regarde les voisins de la case et on les rajoute à la suite
                Do k=1,n
                    bool=((M(ll(j),l(k))==1)).OR.((M(l(k),ll(j))==1))
                    If((j>i).AND.bool.AND.(.NOT.Est_Dans(l(k),ll)))Then
                        prem0=Premier0(ll)
                        ll(prem0)=l(k)
                        Print *,"KI",ll(prem0),j
                    End If
                End Do
                j=j+1
                prem0=Premier0(ll)
            End Do
        End Do

    End Subroutine

    Function KM(M)Result(Res) ! Pour matrices carrées !!!!!!!!

        Real(PR),dimension(:,:),Intent(In)::M
        Real(PR),dimension(Size(M,1),Size(M,1))::Res
        Integer(PR),dimension(Size(M,1),Size(M,1))::Graph ! Graph : lien entre les étiquettes
        Integer(PR),dimension(2,Size(M,1))::degre !  Degre : degré des sommets
        Integer(PR),dimension(Size(M,1))::ordre ! Ordre des sommets
        Integer(PR)::i,j,n

        n=Size(M,1)

        ! Remplissementation de Graph : 1 quand coeff (i,j)<>0 et 0 sinon ( graph est donc orienté )

        Graph=0
        Do i=1,n
            Do j=1,n
                Graph(i,j)=Graph(i,j)+(1-Dirac(0._PR,M(i,j)))
            End Do
        End Do

        ! Détermination ordre des sommets
        degre(2,:)=0
        Do i=1,n
            degre(1,i)=i
            Do j=1,n
                degre(2,i)=degre(2,i)+Graph(i,j)
            End Do
        End Do
        !Print *,degre(2,:)

        Call Tri_bulle(degre(2,:),degre(1,:))
        !Print *,degre(1,:)

        Call Renum(degre(1,:),degre(2,:),Graph,ordre)
        Print *,ordre
        Print *,""

        ! Renumérotation

        Do i=1,n
            Do j=1,n
                Res(i,j)=M(ordre(i),ordre(j))
            End Do
        End Do

    End Function KM

    Function Prod_CSR_Vec(AA,JA,IA,x)Result(y)

        Real(PR),dimension(:),Intent(In)::AA,x
        Integer(PR),dimension(:),Intent(In)::JA,IA
        Real(PR),dimension(Size(x))::y
        Integer(PR)::k,i

        y=0
        Do i=1,Size(IA)-1
            Do k=IA(i),IA(i+1)-1
                y(i)=y(i)+AA(k)*x(JA(k))
            End Do
        End Do

    End Function Prod_CSR_Vec
    
end program name