//
//  main.cpp
//  test
//
//  Created by Mengyi LUO on 2016-07-15.
//  Copyright © 2016 lalaphoon. All rights reserved.
//

#include <iostream>

class Item {
    int value = 0;
};

Item * MakeClassArray(int a_Size){
    Item* newarray = new Item[a_Size];
    return newarray;
}
void deleteClassArray(Item * array){
    delete [] array;
}

Item ** MakeClassPointerArray(int a_Size){
    Item ** newarray = new Item*[a_Size];   ///<-----------------fix 1
    return newarray;
}


void deleteClassPointerArray(Item ** a_arrayptr){
    int size;
    size = (sizeof a_arrayptr/ sizeof a_arrayptr[0]);
    for(int i = 0; i < size; i++){
        deleteClassArray(a_arrayptr[i]);  //<-------------------
    }
        delete [] a_arrayptr;             //<--------------------
    //delete a_arrayptr;
}
int main(int argc, const char * argv[]) {
    
    // insert code here...
    std::cout << "Hello World!\n";
    //Item* haowan = new Item[2];
    Item * arr = MakeClassArray(9);
    deleteClassArray(arr);
    
    Item ** container;
    container = MakeClassPointerArray(10);
    deleteClassPointerArray(container);
    
    return 0;
}
