(import ../bounded-queue :as queue)

(loop [i :range [0 100]]
  (let [cap (max 1 (math/floor (* 0.5 i (math/random))))
        q (queue/new cap)
        gen-v |(string "hello" (math/floor (* 600000 (math/random))))
        vs (seq [_ :range [0 (math/floor (* 10 cap (math/random)))]]
             (gen-v))

        _ (loop [v :in vs] (queue/push q v))

        last-x-vs (array/slice vs (- (min (inc cap) (inc (length vs)))))

        res (seq [v :iterate (queue/pop q)] v)]
    (assert (deep= res last-x-vs)
            (string/format "popped values: %P\n inserted values: %P" res vs))
    (assert (queue/empty? q))))



# not empty after pushing
# empty after clearing
(loop [i :range [0 100]]
  (let [cap (max 1 (math/floor (* 0.5 i (math/random))))
        q (queue/new cap)
        gen-v |(string "hello" (math/floor (* 600000 (math/random))))

        # always push at least one value
        vs (seq [_ :range-to [0 (math/floor (* 10 cap (max 1 (math/random))))]]
             (gen-v))

        _ (loop [v :in vs] (queue/push q v))]
    (assert (not (queue/empty? q)))
    (queue/clear q)
    (assert (queue/empty? q))))
