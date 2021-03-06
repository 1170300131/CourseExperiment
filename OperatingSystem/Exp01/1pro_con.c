#include <stdio.h>
#include <stdlib.h>

typedef struct resource{
    int RID;
    char status;    //resource status F:free A:allocated
    struct pcb *block_list;
    struct resource *next;
    struct resource *pNext;
}RES;

typedef struct pcb{
    int id;     //process id
    char name[20];
    int mem;    //
    RES *res;   //other resource
    char status;//process status  W:wait R:running B:block
    int priority;       //priority
//  struct pcb father;  //generation tree
//  struct pcb son;     //generation tree
    struct pcb *next;
}PCB;

PCB *ready;
PCB *block;
PCB *run;//only one
PCB *prc;
RES *res;

void scheduler(){
    PCB *temp;
    PCB *superTemp=NULL;
    PCB *superLastTemp=NULL;
    PCB *lastTemp=NULL;
    for(temp=ready;temp;temp=temp->next){
        if(superTemp==NULL || temp->priority > superTemp->priority){
            superTemp=temp;
            superLastTemp=lastTemp;
        }
        lastTemp=temp;
    }
    if(ready){
        if(run!=NULL && run->priority < superTemp->priority){
            printf("Process %d is deprived of operation rights\n",run->id);
            if(superLastTemp==NULL){
				ready=run;
			}else{
				superLastTemp->next=superTemp->next;
				lastTemp->next=run;     //Put the run process to the last position of the quene
			}
			run->status='W';
        }
        run=superTemp;
		run->status='R';
		run->next=NULL;
        printf("Process %d starts running\n",run->id);
    }

    //if(self->priority < p->priority || self->status.type!='R'|| self=nil)
    //    preempt(p,self);
}

 void request(int pid,int rid){
    PCB *temp;
    RES *tempRes;
    RES *tempPRes;
    
    if(run->id!=pid){
        printf("This process is not running\n");
        return;
    }
    for(tempRes=run->res;res;tempRes=tempRes->pNext){
        if(tempRes->RID==rid){
            printf("Process %d is using the resource %d\n",pid,rid);
            return;
        }
    }
    for(tempRes=res;tempRes;tempRes=tempRes->next){
        if(tempRes->RID==rid){
            if(tempRes->status=='F'){
                tempRes->status='A';
                if(run->res){
                    for(tempPRes=run->res;tempPRes->pNext!=NULL;tempPRes=tempPRes->pNext);
                    tempPRes->pNext=tempRes;
                }
                else
                    run->res=tempRes;
                printf("Process %d request resource %d successfully\n",pid,rid);
            }
            else{
                if(tempRes->block_list){
                    tempRes->block_list=run;
                    run->status='B';
                    if(block)
                        block=run;
                    else{
                        for(temp=block;temp->next==NULL;temp=temp->next);
                        temp->next=run;
                    }
                    printf("Process %d is blocked",pid);
                    scheduler();
                }
            }
        }
    }
/*  res r=get_RCB(rid);  
    if(r->status=='F'){
        r->status='A';
        insert(self->other_resource,r);
    }else{
        self->status.type='B';
        self->status.list=r;
        remove(RL,self);
        insert(r->waiting,self);
    }
    scheduler();
*/
 }
 void request_(){
    int pid,rid;
    printf("Please type the request pid with process rid\n");
    scanf("%d %d",&rid,&pid);
    request(pid,rid);
 }

void release(int pid,int rid){
    RES *tempRes;
    RES *lastTempRes;
    PCB *temp;
    PCB *temp2;
//  PCB lastTemp;
    if(pid==run->id){
        printf("Process %d is running.you cant release it\n",pid);
    }
    for(tempRes=run->res;tempRes;tempRes=tempRes->pNext){
        if(tempRes->RID==rid){
            lastTempRes->next=tempRes->next;
            printf("Process %d free resource %d successfully",pid,rid);
            tempRes->status='F';
            if(tempRes->block_list!=NULL){
                temp=tempRes->block_list;
                tempRes->block_list=tempRes->block_list->next;

                for(temp2=ready;temp2->next!=NULL;temp2=temp2->next);
                temp2->next=temp;
                temp->status='W';

                for(lastTempRes=temp->res;lastTempRes->next!=NULL;lastTempRes=lastTempRes->pNext)
                    lastTempRes->next=tempRes;
                printf("Blocked process %d get resource\n",temp->id);
                tempRes->status='A';
                printf("Blocked process %d enter ready quene",temp->id);
                if(run->priority < temp->priority){
                    printf("Process %d is deprived of operation rights",run->id);
                    for(temp2=ready;temp2->next!=NULL;temp2=temp2->next);
                    temp2->next=temp;
                    run->status='W';
                    run=temp;
                    run->status='R';
                    printf("Process %d start running",run->id);
                }
                break;

            }
            /*
            for(temp=run->res;temp;temp=temp->pNext){
                if(temp->RID==rid){
                    temp
                }
            }*/
        }
        lastTempRes=tempRes;
    }
/*  r=get_RCB(RID);
    remove(self->other_resource,r);
    if(waiting_list==NULL)
        r->status='F';
    else {
        remove(r->waiting_list,q);
        q->status.type='R';
        q->status.list=RL;
        insert(RL,q);
    }
    scheduler()；
    */
}
void release_(){
    int pid,rid;
    printf("Please type the release rid with process pid\n");
    scanf("%d %d",&rid,&pid);
    release(pid,rid);;
 }

void createInit(){
    PCB *p=(PCB*)malloc(sizeof(PCB));
    p->id=0;
    p->name[0]='i';p->name[1]='n';p->name[2]='i';p->name[3]='t';p->name[4]='\0';
    p->priority=0;
    p->status='R';
    p->next=NULL;
    run=p;
    scheduler();
}

void createProcess(){
    PCB *newProcess=(PCB *)malloc(sizeof(PCB));
    PCB *lastTemp;
    PCB *temp;
    printf("Please type the process id,process name,priority\n");
    scanf("%d %s %d",&(newProcess->id),newProcess->name,&(newProcess->priority));
    newProcess->status='W';
    newProcess->next=NULL;
	if(ready==NULL)
		ready=newProcess;
	else{
		for(temp=ready;temp;temp=temp->next){
			if(temp->id==newProcess->id){
				printf("Process id is repeat\n");
				free(newProcess);
				return;
			}
			lastTemp=temp;
		}
		if(newProcess->priority<0 || newProcess->priority>10){
			printf("The process priority is out of range\n");
			return ;
		}
		lastTemp->next=newProcess;
	}
    printf("Create process successfully\n");
    scheduler();
}

void deleteProcess(){
    PCB *temp;
    PCB *lastTemp;
    int pid;
    printf("Please type the process id\n");
    scanf("%d",&pid);
    if(run->id==pid){
        free(run);
        run=NULL;
        printf("Delete process successfully\n");
        return;
    }
    for(temp=ready;temp;temp=temp->next){
        if(temp->id==pid){
            lastTemp->next=temp->next;
            free(run);
            run=NULL;
            printf("Delete process successfully\n");
            return;
        }
        lastTemp=temp;
    }
    for(temp=block;temp;temp=temp->next){
            if(temp->id==pid){
            lastTemp->next=temp->next;
            free(run);
            run=NULL;
            printf("Delete process successfully\n");
            return;  
        }
        lastTemp=temp;
    }
    printf("Pid is not exist\n");
}

void listAllProcess(){
    PCB *p;
    printf("quene:\tid\tname\tpriority\tstatue\n");
	printf("run:\t%d\t%s\t%d\t\t%c\n",run->id,run->name,run->priority,run->status);
    for(p=ready;p;p=p->next){
        printf("ready:\t%d\t%s\t%d\t\t%c\n",p->id,p->name,p->priority,p->status);
    }
	for(p=block;p;p=p->next){
        printf("block:\t%d\t%s\t%d\t\t%c\n",p->id,p->name,p->priority,p->status);
    }
}

void addResource(){
    RES *temp=NULL;
	RES *lastTemp=NULL;
    RES *newRes;
    int resID;
    printf("Please type the rid\n");
    scanf("%d",&resID);
	for(temp=res;temp;temp=temp->next){
		if(temp->RID==resID){
            printf("RID is repeat\n");
            return ;
        }
        lastTemp=temp;
	}
    newRes=(RES*)malloc(sizeof(RES));
    newRes->RID=resID;
    newRes->status='F';
    newRes->block_list=NULL;
    newRes->next=NULL;
	if(lastTemp)
		res=newRes;
	else
		lastTemp->next=newRes;
    printf("Add resource success successfully\n");
}

void deleteResource(){
    RES *temp;
    RES *lastTemp;
    RES *oprTemp;
    int resID;
    printf("Please type the rid\n");
    scanf("%d",&resID);
    for(temp=res;temp;temp=temp->next){
        if(temp->RID==resID){
            oprTemp=temp->next;
            free(temp);
            lastTemp->next=oprTemp;
            printf("Free resource successfully\n");
        }
        lastTemp=temp;
    }
}

void help(){
    printf("C:Create Process\t D:Delete Process\n");
    printf("A:Add Resource\t\t K:Delete Resource\n");
    printf("N:Request resource\t F:Release Resource\n");
	printf("L:List All Process\t Q:quit\n");
}

int main(){
    char ch='\0';
    ready=NULL;//init quene
    block=NULL;//init quene
    //create a process
    res=NULL;

    help();
    createInit();

    while(ch!='Q'){
        printf(">");
        ch=getchar();
        if(ch>='a' && ch<='z')
            ch=ch+'A'-'a';//Lowercase to uppercase
        switch(ch){
            case 'A':
                addResource();
                break;
            case 'C':
                createProcess();
                break;
            case 'D':
                deleteProcess();
                break;
            case 'K':
                deleteResource();
                break;
            case 'L':
                listAllProcess();
                break;
            case 'N':
                request_();
                break;
            case 'F':
                release_();
                break;
            case '\n':
                continue;
            default:
                printf("Wrong commond\n");
                help();
                break;
        }
    }
    free(res);

}
