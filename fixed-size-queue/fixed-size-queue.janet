(defn push
  [queue item]
  (let [{:capacity c
         :write-i write-i
         :read-i read-i
         :full full} queue
        new-i (mod (inc write-i) c)
        full (or full (= new-i read-i))]
    (when full
      (-> queue
          (put :full true)
          (put :read-i new-i)))

    (-> queue
        (update :items put write-i item)
        (put :write-i new-i))))

(defn pop
  [queue]
  (let [{:capacity c
         :read-i read-i
         :write-i write-i
         :items items
         :full full} queue]
    (if (and (= read-i write-i)
             (not full))
      nil
      (let [new-i (mod (inc read-i) c)
            v (items read-i)]
        (-> queue
            (put :full false)
            (put :read-i new-i))
        v))))

(defn clear-queue
  [queue]
  (-> queue
      (put :full false)
      (put :write-i 0)
      (put :read-i 0)
      (update :items array/clear)))

(defn make-queue
  [capacity]
  @{:items (array/new capacity)
    :capacity capacity
    :read-i 0
    :write-i 0
    :full false})
