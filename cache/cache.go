// Package cache defines the interface that all the caches must implement
package cache

// Cache is the default interface that all caches implement
type Cache interface {
	Get(key string) (string, bool)
	Set(key, value string, ttl int64)
	Contains(Key string) bool
	Size() int64
	Del(key string)
}
