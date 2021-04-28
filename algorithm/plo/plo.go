// Package plo provides ...
package plo

import (
	"math/big"
)

// lands need be sorted by `sort.Strings(lands)`
func Pick(lands []string, hash *big.Int) string {
	length := int64(len(lands))
	if length == 0 {
		return ""
	}
	n := new(big.Int).Mod(hash, big.NewInt(length))
	return lands[n.Int64()]
}
