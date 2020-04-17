#include <substrate.h>

void resolveSymbol(const void *addr) {
  Dl_info info;
  if (dladdr(addr, &info)) {
    NSLog(@"<hooksubstrate> Resolved symbol at address %p: dli_fname %s, dli_fbase %p, dli_sname %s, dli_saddr %p", addr, info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr);
  }
  else {
    NSLog(@"<hooksubstrate> Can't resolve symbol at address %p", addr);
  }
}

void (*oldMSHookFunction)(void *, void *, void **);

void newMSHookFunction(void *symbol, void *hook, void **old) {
  // NSLog(@"<hooksubstrate> MSHookFunction: symbol %p, new %p, old %p", symbol, hook, old);
  // resolveSymbol(symbol);
  // resolveSymbol(hook);
  // resolveSymbol(old);
  NSLog(@"hao-hooked");
  oldMSHookFunction(symbol, hook, old);
}

void (*oldMSHookMessageEx)(Class, SEL, IMP, IMP *);

void newMSHookMessageEx(Class c/*lass*/, SEL s/*elector*/, IMP replacement, IMP *result) {
  NSLog(@"<hooksubstrate> MSHookMessageEx: class %@, selector %@, new %p, old %p", NSStringFromClass(c/*lass*/), NSStringFromSelector(s/*elector*/), replacement, result);
  resolveSymbol((const void *) *replacement);
  resolveSymbol((const void *) result);
  oldMSHookMessageEx(c/*lass*/, s/*elector*/, replacement, result);
}

__attribute__((constructor))
static void initialize() {
  // MSHookFunction(MSHookMessageEx, &newMSHookMessageEx, &oldMSHookMessageEx);
  // MSHookFunction(MSHookFunction, &newMSHookFunction, &oldMSHookFunction);
  // MSHookFunction(((void*)MSFindSymbol(NULL, "_MSHookMessageEx")), (void*)newMSHookMessageEx, (void**)&oldMSHookMessageEx);
  // MSHookFunction(((void*)MSFindSymbol(NULL, "_MSHookFunction")), (void*)newMSHookFunction, (void**)&oldMSHookFunction);
  NSLog(@"<hooksubstrate> Hooked into MSHookFunction & MSHookMessageEx");
}
