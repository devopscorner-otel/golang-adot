package controller

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/devopscorner/golang-adot/src/config"
	"github.com/devopscorner/golang-adot/src/routes"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var (
	routerLogin *gin.Engine
)

func TestLoginController_Main(t *testing.T) {
	gin.SetMode(gin.TestMode)
	config.LoadConfig()
	routerLogin = gin.Default()
	routes.SetupRoutes(routerLogin)
}

func TestLoginController_CreateToken(t *testing.T) {
	// Set up the test request
	loginRequest := LoginRequest{Username: "admin", Password: "password"}
	jsonRequest, _ := json.Marshal(loginRequest)
	req, _ := http.NewRequest(http.MethodPost, "/login", bytes.NewBuffer(jsonRequest))
	req.Header.Set("Content-Type", "application/json")

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerLogin.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var responseBody map[string]string
	err := json.Unmarshal(w.Body.Bytes(), &responseBody)
	assert.NoError(t, err)

	assert.NotEmpty(t, responseBody["token"])
}
