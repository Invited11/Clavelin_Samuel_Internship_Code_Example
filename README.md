# Clavelin_Samuel_Internship_Code_Example

The python code : made there is three years for my project dealing with quantum cryptography and quantum computing. The aim is to « show » that the QBER is adapted to detect the espionage almost every time. So I verified that for more than a specific number of qubit the spying let a footprint that makes the error lower than the QBER and so that the spying cannot be confused with the decoherence through detected errors. Even though this is a classical algorithm.

So for 300 photons I simulate the spying 1.000 time for every sizes of ‘controlling photon’ ( I don’t know if this is the exact term ; I mean photons which are « sacrificed » to know if spying occurred or not ). For BB84, the QBER I took is 0.89.

I joined graphs of the higher rate of coherence for the 1.000 tests for each of the controlling photon size, of the average of rates and of the number of exceeding of the QBER.

 

The Qiskit code : this is a little and very easy code I made on a previous version of Qiskit from IBM. The only goal of this code was to show a basic ‘quantum tool’ and to illustrate the effects of Hadamard’s gate, still for my project on quantum cryptography and algorithms ( in the section of Shor's algorithm ).

( It was nicer to write the code on LaTeX than to take a screenshot from Qiskit. And I really like to write on LaTeX too ! )

 

The Fortran90 code : Not the biggest code in F90 we made during the first year of engineering school but I thought this one relevant because we had no ‘instructions’ on how to code these algorithms, we were totally free.

I implemented the CSR storage, a way to store more efficiently sparse matrix. Pretty direct to implement.

The second algorithm is the Kuthill McKee renumbering. For sparse matrix too, it reorganizes elements of the initial matrix around the diagonal. What was interesting was that this algorithm uses graphs theory and list sorting. But we weren’t learned how to implement graphs on F90 and this language is not very efficient for recursion and does not make any difference between lists and arrays, in the contrary of OCAML. So we had to find a way to implement it iteratively.

You compile classically ( with ‘make’ ) and then execute with ‘./CKM’.

 

The C++ code ( the .zip file ) : Our homework for these Christmas holidays, the goal is to handle meshes of a kettle to see the best way to model the evolution of the temperature, with boundaries condition, source term and advection and diffusion phenomena. We used Finite Volume. Two classical time schemes and spatial schemes are used. These files has been coded in collaboration with our professors. There, the real difficulty was to keep an overview of all functions and files of the homework, required by the relative complexity of the subject.

In the file Code_version_initiale you compile classically ( with ‘make’ ) and then execute with ‘./run name_of_a_data_file’ ( for example, name_of_a_data_file could be Data/MatrixRHSValidation/data_diffusion_advection_all_BC.toml ).

 

 

I am sorry for comments in French in my algorithms, I didn’t have the time to correct all.

And none of these algorithms are optimized, it wasn’t the goal of the first three semesters. But next semester we will learn optimization in HPC.
