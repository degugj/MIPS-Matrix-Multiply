int a[] = {7, 16, 23, 40, 11, 39, 37, 10, 2,18};
int prime[] = {0, 0, 0, 0, 0};
int composite[] = {0, 0, 0, 0, 0};
int isPrime(int n){
int i = 0;
for(i=2; i<=n/2; ++i)
{
		if(n%i == 0)
		{
			return 0;
		}
}
	return 1;
}
int main(){
int i = 0, j = 0, k = 0;
int d = 0;
	while(i < 10) {
		d = isPrime(a[i]);
		if(d == 1)
		{
			prime[j] = a[i];
			J++;
		}
		else{
			composite[k] = a[i];
			K++;
		}
	i++;
}
return 0;
}
