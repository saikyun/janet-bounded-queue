(use ../fixed-size-queue/fixed-size-queue)

(loop [i :range [0 100]]
  (let [cap (max 1 (math/floor (* 0.5 i (math/random))))
        q (make-queue cap)
        gen-v |(string "hello" (math/floor (* 600000 (math/random))))
        vs (seq [_ :range [0 (math/floor (* 10 cap (math/random)))]]
             (gen-v))

        _ (loop [v :in vs] (push q v))

        last-x-vs (array/slice vs (- (min (inc cap) (inc (length vs)))))

        res (seq [v :iterate (pop q)] v)]
    (assert (deep= res last-x-vs)
            (string/format "popped values: %P\n inserted values: %P" res vs))))
