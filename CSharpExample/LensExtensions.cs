using System;
using FSharpx;

namespace CSharpExample {
    public static class LensExtensions {
        public static D Get<S,D>(this Lens<S,D> lens, S source) {
            return lens.Get.Invoke(source);
        }

        public static S Set<S,D>(this Lens<S,D> lens, S source, D newValue) {
            return lens.Set.Invoke(newValue).Invoke(source);
        }

        public static S Update<S,D>(this Lens<S,D> lens, S source, Func<D,D> update) {
            var ff = FSharpFunc.FromFunc(update);
            return lens.Update(ff, source);
        }
    }
}
